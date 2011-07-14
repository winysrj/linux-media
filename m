Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32908 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1GNJpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 05:45:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: Re: [PATCH 2/3] Document 8-bit and 16-bit YCrCb media bus pixel codes
Date: Thu, 14 Jul 2011 11:45:33 +0200
Cc: linux-media@vger.kernel.org
References: <CAH9NwWc+zLqPyBcC99wbsbNkdjzMFfn2zuGm1VfmZctgpOGMew@mail.gmail.com> <CAH9NwWecm8MUDNJPCaaWbA-6cX66foJnH7-S5CF7_nq9yg5U9A@mail.gmail.com> <CAH9NwWdSkpVYg9px9Wxr_yCvo4m2vU+L6A=cyVYG_+-s2RFMpQ@mail.gmail.com>
In-Reply-To: <CAH9NwWdSkpVYg9px9Wxr_yCvo4m2vU+L6A=cyVYG_+-s2RFMpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107141145.34176.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christian,

On Wednesday 13 July 2011 20:58:12 Christian Gmeiner wrote:
> 2011/7/11 Christian Gmeiner <christian.gmeiner@gmail.com>:
> > 2011/7/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> On Sunday 10 July 2011 20:14:21 Christian Gmeiner wrote:
> >>> Signed-off-by: Christian Gmeiner
> >>> ---
> >>> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> >>> b/Documentation/DocBook/media/v4l/subdev-formats.xml
> >>> index 49c532e..18e30b0 100644
> >>> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> >>> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> >>> @@ -2565,5 +2565,43 @@
> >>>         </tgroup>
> >>>        </table>
> >>>      </section>
> >>> +
> >>> +    <section>
> >>> +      <title>YCrCb Formats</title>
> >>> +
> >>> +      <para>YCbCr represents colors as a combination of three values:
> >>> +      <itemizedlist>
> >>> +       <listitem><para>Y - the luminosity (roughly the
> >>> brightness)</para></listitem>
> >>> +       <listitem><para>Cb - the chrominance of the blue
> >>> primary</para></listitem>
> >>> +       <listitem><para>Cr - the chrominance of the red
> >>> primary</para></listitem>
> >> 
> >> How does that differ from YUV ?
> > 
> > I need to say that I am very new to this whole format stuff and so I
> > am not really sure.
> > In the data sheet
> > http://dxr3.sourceforge.net/download/hardware/ADV7175A_6A.pdf there is
> > on the
> > first page a FUNCTIONAL BLOCK DIAGRAM which shows that there is a
> > "YCrCb to YUV Matrix"
> > stage in the pipeline. I am also fine to use a YUV format for the media
> > bus. Any suggestions?
> 
> Okay I think I have found the difference between YUV and YCrCb - see [1]
> 
> YCbCr 4:2:2
> (Redirected from YUV 4:2:2)
> 
> FourCCs: YUY2, UYVY, YUV2 (Apple Component Video stored in MOV files)
> Samples: http://samples.mplayerhq.hu/V-codecs/YUV2/
> 
> (These FourCC names only reflect that the YCbCr of digital media is
> often falsely mixed up with analog PAL's YUV color space.)
> 
> YCbCr 4:2:2 is a packed YCbCr format in which a pair of consecutive
> pixels is represented by 1 Y sample each but share a Cb sample and a
> Cr sample.
> 
> This type of data may be packaged in a container format with a a
> FourCC of YUY2 which indicates the following byte formatting:
> 
> 
> [1] http://wiki.multimedia.cx/index.php?title=YUV_4:2:2

According to http://en.wikipedia.org/wiki/Yuv,

"Historically, the terms YUV and Y'UV were used for a specific analog encoding 
of color information in television systems, while YCbCr was used for digital 
encoding of color information suited for video and still-image compression and 
transmission such as MPEG and JPEG. Today, the term YUV is commonly used in 
the computer industry to describe file-formats that are encoded using YCbCr."

V4L2 seems to suffer from the ambiguity, as we use YUV as generic term to mean 
a digital luma/chroma format. I thus think your driver should use the existing 
YUV pixel codes.

-- 
Regards,

Laurent Pinchart
