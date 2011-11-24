Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53269 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754991Ab1KXXfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:35:00 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
Date: Fri, 25 Nov 2011 00:32:44 +0100
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <4ECE79F5.9000402@linuxtv.org> <4ECE80BE.4090109@redhat.com>
In-Reply-To: <4ECE80BE.4090109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111250032.46260@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 24 November 2011 18:37:02 Mauro Carvalho Chehab wrote:
> Userspace applications that support av7110 can include the new linux/av7110.h
> header. Other applications that support out-of-tree drivers can just have
> their own copy of audio.h, osd.h and video.h. So, it won't break or prevent
> existing applications to keep working.

No way! Changes of the user-space API are not acceptable.
If you do not believe that, ask Linux Torwalds!

> The thing is that the media API presents two interfaces to control mpeg decoders.
> This is confusing, and, while one of them has active upstream developers working
> on it, adding new drivers and new features on it, the other API is not being
> updated accordingly, and no new upstream drivers use it.

The decoder API is as old as the DVB spec.

NACK to any attempts to remove these files.

Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
