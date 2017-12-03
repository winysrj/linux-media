Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46135 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdLCFji (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 00:39:38 -0500
Date: Sun, 3 Dec 2017 08:39:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: atomisp: convert default struct values to
 use compound-literals with designated initializers.
Message-ID: <20171203053921.tvvvttx63zi2p725@mwanda>
References: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
 <20171201171939.3432-1-jeremy@azazel.net>
 <20171201171939.3432-2-jeremy@azazel.net>
 <20171202102009.pdly5urlxkt4rdcx@mwanda>
 <20171202103506.4ffadm3qkxtv3rge@azazel.net>
 <20171202204147.GB32301@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171202204147.GB32301@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 02, 2017 at 08:41:48PM +0000, Jeremy Sowden wrote:
> On 2017-12-02, at 10:35:06 +0000, Jeremy Sowden wrote:
> > On 2017-12-02, at 13:20:09 +0300, Dan Carpenter wrote:
> > > On Fri, Dec 01, 2017 at 05:19:37PM +0000, Jeremy Sowden wrote:
> > > > -#define DEFAULT_PIPE_INFO \
> > > > -{ \
> > > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* output_info */ \
> > > > -	{IA_CSS_BINARY_DEFAULT_FRAME_INFO},	/* vf_output_info */ \
> > > > -	IA_CSS_BINARY_DEFAULT_FRAME_INFO,	/* raw_output_info */ \
> > > > -	{ 0, 0},				/* output system in res */ \
> > > > -	DEFAULT_SHADING_INFO,			/* shading_info */ \
> > > > -	DEFAULT_GRID_INFO,			/* grid_info */ \
> > > > -	0					/* num_invalid_frames */ \
> > > > -}
> > > > +#define DEFAULT_PIPE_INFO ( \
> > >
> > > Why does this have a ( now?  That can't compile can it??
> >
> > It does.
> 
> That was a bit terse: the macros expand to compound-literals, so
> putting parens around them is no different from:
> 
>   #define THREE (3)

Yeah.  Thanks.  I figured it out despite the terseness...  I try review
as fast as I can, so it means you get the stream of conciousness output
that often has mistakes.  Sorry about that.

regards,
dan carpenter
