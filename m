Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59488
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751740AbdIXKfn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 06:35:43 -0400
Date: Sun, 24 Sep 2017 07:35:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scripts: kernel-doc: fix nexted handling
Message-ID: <20170924073533.7a5afed5@vento.lan>
In-Reply-To: <998D6C15-4125-49F1-936E-9977C66E95A6@darmarit.de>
References: <a788284f66d113ceec57dd6f66b1d024e7b1ddf1.1505924829.git.mchehab@s-opensource.com>
        <998D6C15-4125-49F1-936E-9977C66E95A6@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Sep 2017 14:44:34 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > Jon,
> > 
> > While documenting some DVB demux  headers, I noticed the above bug.
> > 
> > scripts/kernel-doc | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > index 9d3eafea58f0..15f934a23d1d 100755
> > --- a/scripts/kernel-doc
> > +++ b/scripts/kernel-doc
> > @@ -2173,7 +2173,7 @@ sub dump_struct($$) {
> > 	my $members = $3;
> > 
> > 	# ignore embedded structs or unions
> > -	$members =~ s/({.*})//g;
> > +	$members =~ s/({[^\}]*})//g;
> > 	$nested = $1;
> > 
> > 	# ignore members marked private:  
> 
> Hi Mauro,
> 
> I tested this patch. Feel free to add my
> 
>  Tested-by: Markus Heiser <markus.heiser@darmarit.de>
> 
> FYI: I also migrated the patch to my python kernel-doc parser:
> 
>    https://github.com/return42/linuxdoc/commit/5dbb93f
> 
> And here is the impact of this patch on the whole sources:
> 
>    https://github.com/return42/sphkerneldoc/commit/7be0fa85
> 
> In the last link, you see that your patch is a great improvement / Thanks!!

I actually got some issues with this patch, when there are multiple
embedded structs, like here:


/**
 * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
 *
 * @match_type:	type of match that will be used
 * @match:	union of per-bus type matching data sets
 * @list:	used to link struct v4l2_async_subdev objects, waiting to be
 *		probed, to a notifier->waiting list
 */
struct v4l2_async_subdev {
	enum v4l2_async_match_type match_type;
	union {
		struct {
			struct fwnode_handle *fwnode;
		} fwnode;
		struct {
			const char *name;
		} device_name;
		struct {
			int adapter_id;
			unsigned short address;
		} i2c;
		struct {
			bool (*match)(struct device *,
				      struct v4l2_async_subdev *);
			void *priv;
		} custom;
	} match;

	/* v4l2-async core private: not to be used by drivers */
	struct list_head list;
};

With this patch, it would identify the union as:
	union fnode;

Instead of:
	union match;

I just sent a new patch that works interactively until it gets rid of 
all nested struct in the right way.


The regex should be:

	while ($members =~ s/({[^\{\}]*})//g) {};

This will get rid of the nested structs level by level. We can
see how it works by using this:

	# ignore embedded structs or unions
	print STDERR "MEMBERS=$members\n";
	while ($members =~ s/({[^\{\}]*})//g) { print STDERR "MEMBERS=$members\n"; };

The result is:

MEMBERS= enum v4l2_async_match_type match_type; union { struct { struct fwnode_handle *fwnode; }  fwnode; struct { const char *name; }  device_name; struct { int adapter_id; unsigned short address; }  i2c; struct {bool (*match)(struct device *, struct v4l2_async_subdev *); void *priv; }  custom; }  match;/* v4l2-async core private: not to be used by drivers */ struct list_head list; 
MEMBERS= enum v4l2_async_match_type match_type; union { struct   fwnode; struct   device_name; struct   i2c; struct   custom; }  match;/* v4l2-async core private: not to be used by drivers */ struct list_head list; 
MEMBERS= enum v4l2_async_match_type match_type; union   match;/* v4l2-async core private: not to be used by drivers */ struct list_head list; 

With is what we actually want to do there.


Thanks,
Mauro
