Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46694 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3AKMZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 07:25:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 2/2] DocBook: improve the error_idx field documentation.
Date: Fri, 11 Jan 2013 13:27:04 +0100
Message-ID: <2288686.TWxMZHUWFA@avalon>
In-Reply-To: <201301111322.08472.hverkuil@xs4all.nl>
References: <1357903563-5788-1-git-send-email-hverkuil@xs4all.nl> <3074833.VDmUTZxrWA@avalon> <201301111322.08472.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 11 January 2013 13:22:08 Hans Verkuil wrote:
> On Fri January 11 2013 13:13:47 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > Thanks for the patch. This is much better in my opinion, please see below
> > for two small comments.
> > 
> > On Friday 11 January 2013 12:26:03 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > The documentation of the error_idx field was incomplete and confusing.
> > > This patch improves it.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > > 
> > >  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   44
> > >  +++++++++++++----
> > >  1 file changed, 37 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> > > b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml index
> > > 0a4b90f..e9f9735 100644
> > > --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> > > +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> > > @@ -199,13 +199,43 @@ also be zero.</entry>
> > > 
> > >  	  <row>
> > >  	  
> > >  	    <entry>__u32</entry>
> > >  	    <entry><structfield>error_idx</structfield></entry>
> > > 
> > > -	    <entry>Set by the driver in case of an error. If it is equal
> > > -to <structfield>count</structfield>, then no actual changes were made
> > > -to controls. In other words, the error was not associated with setting
> > > -a particular control. If it is another value, then only the controls up
> > > -to <structfield>error_idx-1</structfield> were modified and control
> > > -<structfield>error_idx</structfield> is the one that caused the error.
> > > -The <structfield>error_idx</structfield> value is undefined if the
> > > -ioctl returned 0 (success).</entry>
> > > +	    <entry><para>Set by the driver in case of an error. If the error
> > > +is associated with a particular control, then
> > > +<structfield>error_idx</structfield> is set to the index of that
> > > +control. If the error is not related to a specific control, or the
> > > +pre-validation step failed (see below), then
> > > +<structfield>error_idx</structfield> is set to
> > > +<structfield>count</structfield>. The value is undefined if the ioctl
> > > +returned 0 (success).</para>
> > > +
> > > +<para>Before controls are read from/written to hardware a
> > > +pre-validation
> > 
> > Maybe s/pre-validation/validation/ through the text ? We have a single
> > validation step, it feels a bit weird to talk about pre-validation when
> > there's no further validation :-)
> 
> OK.
> 
> > > +step takes place: this checks if all controls in the list are all valid
> > 
> > s/all valid/valid/ ?
> 
> Indeed.
> 
> > > +controls, if no attempt is made to write to a read-only control or read
> > > +from a write-only control, and any other up-front checks that can be
> > > done
> > > +without accessing the hardware.</para>
> 
> How about adding this sentence to the end of the paragraph:
> 
> "The exact validations done during this step are driver dependent since some
> checks might require hardware access for some devices, thus making it
> impossible to do those checks up-front. However, drivers should make a
> best-effort to do as many up-front checks as possible."

Sounds very good to me. With all those changes,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

