Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:30520 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2IMKs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:48:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 API PATCH 14/28] DocBook: clarify that sequence is also set for output devices.
Date: Thu, 13 Sep 2012 12:48:23 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <218a8f843734b9b2572842bc817ed36970931c24.1347023744.git.hans.verkuil@cisco.com> <1972373.6VO1sanVZv@avalon>
In-Reply-To: <1972373.6VO1sanVZv@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131248.23818.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 13 September 2012 04:28:41 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 07 September 2012 15:29:14 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > It was not entirely obvious that the sequence count should also
> > be set for output devices. Also made it more explicit that this
> > sequence counter counts frames, not fields.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  Documentation/DocBook/media/v4l/io.xml |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > b/Documentation/DocBook/media/v4l/io.xml index b680d66..d1c2369 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -617,8 +617,8 @@ field is independent of the
> > <structfield>timestamp</structfield> and <entry>__u32</entry>
> >  	    <entry><structfield>sequence</structfield></entry>
> >  	    <entry></entry>
> > -	    <entry>Set by the driver, counting the frames in the
> > -sequence.</entry>
> > +	    <entry>Set by the driver, counting the frames (not fields!) in the
> > +sequence. This field is set for both input and output devices.</entry>
> 
> Nitpicking, s/in the sequence/in sequence/ ?

Will fix.

Regards,

	Hans

> 
> >  	  </row>
> >  	  <row>
> >  	    <entry spanname="hspan"><para>In <link
> 
> 
