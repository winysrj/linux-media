Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2746 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3AKLs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 06:48:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [REVIEW PATCHv1 1/2] DocBook: improve the error_idx field documentation.
Date: Fri, 11 Jan 2013 12:48:19 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1357560588-5263-1-git-send-email-hverkuil@xs4all.nl> <50256813dbb6df25776aed847787d1eac9dbc9fa.1357560529.git.hans.verkuil@cisco.com> <5589342.kjDUmhmVqU@avalon>
In-Reply-To: <5589342.kjDUmhmVqU@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111248.19511.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 7 2013 20:56:07 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Monday 07 January 2013 13:09:47 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The documentation of the error_idx field was incomplete and confusing.
> > This patch improves it.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   51 ++++++++++++++---
> >  1 file changed, 44 insertions(+), 7 deletions(-)
> 
> (Text reflowed for easier review)
> 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> > b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml index
> > 0a4b90f..c07c657 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
> > @@ -199,13 +199,50 @@ also be zero.</entry>
> >  	  <row>
> >  	    <entry>__u32</entry>
> >  	    <entry><structfield>error_idx</structfield></entry>
> > -	    <entry>Set by the driver in case of an error. If it is equal
> > -to <structfield>count</structfield>, then no actual changes were made to
> > -controls. In other words, the error was not associated with setting a
> > -particular control. If it is another value, then only the controls up to
> > -<structfield>error_idx-1</structfield> were modified and control
> > -<structfield>error_idx</structfield> is the one that caused the error. The
> > -<structfield>error_idx</structfield> value is undefined if the ioctl
> > -returned 0 (success).</entry>
> > +	    <entry><para>Set by the driver in case of an error. If the error is
> > +associated with a particular control, then
> > +<structfield>error_idx</structfield> is set to the index of that control.
> > +If the error is not related to a specific control, then
> > +<structfield>error_idx</structfield> is set to
> > +<structfield>count</structfield>.</para>
> > +<para>The behavior is different for <constant>VIDIOC_G_EXT_CTRLS</constant>
> > +and <constant>VIDIOC_S_EXT_CTRLS</constant>: if
> > +<structfield>error_idx</structfield> is equal to
> > +<structfield>count</structfield>, then no actual changes were made to the
> > +controls. For example, if you try to write to a read-only control, then
> > +<constant>VIDIOC_TRY_EXT_CTRLS</constant> will set
> > +<structfield>error_idx</structfield> to the index of that read-only
> > +control, but <constant>VIDIOC_S_EXT_CTRLS</constant> will set
> > +<structfield>error_idx</structfield> to <structfield>count</structfield>
> > +instead and none of the controls in the list will be set.</para>
> 
> I find this a bit confusing (although I understand what you mean, as I'm 
> familiar with the API). You start by mentioning [GS]_EXT_CTRLS only, and then 
> you introduce TRY_EXT_CTRLS in the example. I think it would be clearer if you 
> restructed the explanation as follows:
> 
> - explain the error_idx principle globally, withotu examples
> - explain that [GS]_EXT_CTRLS will perform pre-validation and will thus set 
> error_idx to count in specific cases (they should be listed)
> - explain that TRY_EXT_CTRLS doesn't perform pre-validation and will thus set 
> error_idx to the index of the erroneous control in all cases, including the 
> specific cases listed for [GS]_EXT_CTRLS

I've rewritten the text completely using some of your ideas. I hope it is
now easier to understand.

> > +<para>The same is true when trying to e.g. read a write-only control:
> > +<constant>VIDIOC_G_EXT_CTRLS</constant> will set
> > +<structfield>error_idx</structfield> to <structfield>count</structfield>
> > +and none of the controls in the list will have been retrieved.</para>
> > +
> > +<para>The reason for this behavior is that it is important when setting and
> > +getting controls to do this as atomically as possible, so simple sanity
> > +checks like testing for read-only controls are done first before an
> > +attempt is made to apply/retrieve the new control values to/from the
> > +hardware. It is important for an application to know whether
> > +<constant>VIDIOC_S_EXT_CTRLS</constant> or
> > +<constant>VIDIOC_G_EXT_CTRLS</constant> actually made changes to controls
> > +or not. So if <structfield>error_idx</structfield> is equal to
> > +<structfield>count</structfield>, then you know that no actual controls
> > +were set or retrieved. In the case of
> > +<constant>VIDIOC_S_EXT_CTRLS</constant> you can call
> > +<constant>VIDIOC_TRY_EXT_CTRLS</constant> with the same control list to
> > +see if the problem was with a specific control or not
> > +(<constant>VIDIOC_TRY_EXT_CTRLS</constant> never modifies controls, so
> > +that ioctl will just set <structfield>error_idx</structfield> to the
> > +control that caused the problem). No such option exists for
> > +<constant>VIDIOC_G_EXT_CTRLS</constant> though, unfortunately.</para>
> 
> It's very unfortunate indeed :-) Given that the hardware state must not be 
> changed by a read operation, are you sure G_EXT_CTRLS couldn't retrieve 
> controls up to the erroneous one ? ;-)

No, I don't want to change it. One option we have if it becomes clear in the
future that this information is really needed is to take one of the reserved
fields from struct v4l2_ext_controls and use that to report such information.

Another alternative is to improve debugging in v4l2-ctrls.c and, if debugging is
on, print which control failed the check for what reason.

> I think some flexibility should still probably be left to drivers (and I'm not 
> talking about UVC here), as some drivers might not be able to know that a 
> control is write-only before trying to read it and getting an error.

Well, if drivers don't know if a control is e.g. write-only until they try it,
then it can't be done during pre-validation anyway, so that's no problem.

The pre-validation should at minimum check whether ctrl_class is set up correctly,
whether all controls in the list actually exist, and check against READ_ONLY
or WRITE_ONLY (if known upfront).

The v4l2-compliance tool will test those minimum checks.

The control framework will also check whether the GRABBED flag is set for
a control and if the new value of a control is valid.

Regards,

	Hans
