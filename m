Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:26653 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3EGQrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 12:47:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC PATCH for 3.10] Update Codec section in DocBook
Date: Tue, 7 May 2013 18:47:01 +0200
Cc: "'linux-media'" <linux-media@vger.kernel.org>
References: <201305071406.11826.hverkuil@xs4all.nl> <036001ce4b39$8e775f50$ab661df0$%debski@samsung.com>
In-Reply-To: <036001ce4b39$8e775f50$ab661df0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305071847.01169.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 7 May 2013 17:42:57 Kamil Debski wrote:
> Hi Hans,
> 
> Thanks for this patch. I remember that there was some discussion about it
> and
> the conclusion was that a codec device is in fact a mem-2-mem device. This
> probably is the reason why codec documentation was not extended.
> 
> Ack on my side.
> 
> Hans, do you expect me to pull this or will you deal directly with Mauro?

If you have anything pending for 3.10, then it might be easier if you just
add it for that. If not, then I can just create a 3.10 branch myself and
make a pull request for Mauro.

Regards,

	Hans

> 
> Best wishes,
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Tuesday, May 07, 2013 2:06 PM
> > To: linux-media
> > Cc: Kamil Debski
> > Subject: [RFC PATCH for 3.10] Update Codec section in DocBook
> > 
> > I had feedback from two companies recently that they thought V4L2
> > didn't support codec hardware because the Codec section in the spec
> > said it was 'suspended'.
> > 
> > That's really bad so I made a quick patch for this that I'd like to get
> > into
> > 3.10 because of the unintended high impact this outdated documentation
> > has.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > Subject: [PATCH] DocBook: media: update codec section, drop obsolete
> > 'suspended' state.
> > 
> > The Codec section in the V4L2 specification was marked as 'suspended',
> > even though codec support has been around for quite some time. Update
> > this section, explaining a bit about memory-to-memory devices and
> > pointing to the MPEG controls section.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Kamil Debski <k.debski@samsung.com>
> 
> > ---
> >  Documentation/DocBook/media/v4l/dev-codec.xml |   35 ++++++++++++++++-
> > --------
> >  1 file changed, 22 insertions(+), 13 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/dev-codec.xml
> > b/Documentation/DocBook/media/v4l/dev-codec.xml
> > index dca0ecd..ff44c16 100644
> > --- a/Documentation/DocBook/media/v4l/dev-codec.xml
> > +++ b/Documentation/DocBook/media/v4l/dev-codec.xml
> > @@ -1,18 +1,27 @@
> >    <title>Codec Interface</title>
> > 
> > -  <note>
> > -    <title>Suspended</title>
> > +  <para>A V4L2 codec can compress, decompress, transform, or otherwise
> > +convert video data from one format into another format, in memory.
> > +Typically such devices are memory-to-memory devices (i.e. devices with
> > +the <constant>V4L2_CAP_VIDEO_M2M</constant> or
> > +<constant>V4L2_CAP_VIDEO_M2M_MPLANE</constant>
> > +capability set).
> > +</para>
> > 
> > -    <para>This interface has been be suspended from the V4L2 API
> > -implemented in Linux 2.6 until we have more experience with codec -
> > device interfaces.</para>
> > -  </note>
> > +  <para>A memory-to-memory video node acts just like a normal video
> > +node, but it supports both output (sending frames from memory to the
> > +codec hardware) and capture (receiving the processed frames from the
> > +codec hardware into memory) stream I/O. An application will have to
> > +setup the stream I/O for both sides and finally call &VIDIOC-STREAMON;
> > +for both capture and output to start the codec.</para>
> > 
> > -  <para>A V4L2 codec can compress, decompress, transform, or otherwise
> > -convert video data from one format into another format, in memory.
> > -Applications send data to be converted to the driver through a -&func-
> > write; call, and receive the converted data through a -&func-read; call.
> > For efficiency a driver may also support streaming -I/O.</para>
> > +  <para>Video compression codecs use the MPEG controls to setup their
> > +codec parameters (note that the MPEG controls actually support many
> > more codecs than just MPEG).
> > +See <xref linkend="mpeg-controls"></xref>.</para>
> > 
> > -  <para>[to do]</para>
> > +  <para>Memory-to-memory devices can often be used as a shared
> > +resource: you can open the video node multiple times, each application
> > +setting up their own codec properties that are local to the file
> > handle, and each can use it independently from the others.
> > +The driver will arbitrate access to the codec and reprogram it
> > whenever
> > +another file handler gets access. This is different from the usual
> > +video node behavior where the video properties are global to the
> > device
> > +(i.e. changing something through one file handle is visible through
> > +another file handle).</para>
> > --
> > 1.7.10.4
> 
> 
