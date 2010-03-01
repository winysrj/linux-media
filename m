Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2685 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0CAHpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 02:45:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Announcing v4l-utils-0.7.90 (which includes libv4l-0.7.90)
Date: Mon, 1 Mar 2010 08:45:50 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4B882457.1050006@hhs.nl>
In-Reply-To: <4B882457.1050006@hhs.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003010845.50657.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 26 February 2010 20:43:19 Hans de Goede wrote:
> Hi,
> 
> I'm happy to announce the first (test / beta) release of v4l-utils,
> v4l-utils is the combination of various v4l and dvb utilities which
> used to be part of the v4l-dvb mercurial kernel tree and libv4l.

Is it correct that I only see v4l utilities and no dvb?
 
> I encourage people to give this version a spin. I esp. would like
> feedback on which v4l / dvb utilities should end up being installed
> by make install. For now I've stuck with what the Makefile in v4l2-apps
> did. See README for a list of all utilities and if they are currently
> installed or not.

qv4l2-qt3 should either be dropped altogether (my preference, although Mauro
thinks differently), or be moved to contrib. I think it is nuts to keep that
one around since the qt4 version is much, much better and the qt3 version is
no longer maintained anyway.

xc3028-firmware, v4l2-compliance and rds should also be moved to contrib.

I'm not sure about decode_tm6000, keytable and v4l2-sysfs-path. These too
may belong to contrib.

We definitely want to have alevtv here as well (it's currently in dvb-apps).

> If you are doing distribution packaging of libv4l, note that the
> good old libv4l tarbal releases are going away, libv4l will now
> be released as part of v4l-utils, and you are encouraged to
> package that up completely including the included utilities. As
> I'm doing distro package maintenance  myself I know this is a pain,
> but in the long run having a single source for v4l + dvb userspace tools
> and libraries is for the best.
> 
> New this release:
> 
> v4l-utils-0.7.90
> ----------------
> * This is the first release of v4l-utils, v4l-utils is the combination
>    of various v4l and dvb utilities which used to be part of v4l-dvb
>    mercurial kernel tree and libv4l.
> * This first version is 0.7.90, as the version numbers continue were libv4l
>    as a standalone source archive stops.
> * libv4l changes:
>    * Add more laptop models to the upside down devices table
>    * Fix Pixart JPEG ff ff ff xx markers removal, this fixes the occasional
>      corrupt frame we used to get (thanks to Németh Márton)
>    * Enable whitebalance by default on various sonixj based cams
>    * Enable whitebalance + gamma correction by default on all sonixb cams
>    * Enable gamma correction by default on pac7302 based cams
> 
> Go get it here:
> http://people.fedoraproject.org/~jwrdegoede/v4l-utils-0.7.90.tar.bz2
> 
> You can always find the latest developments here:
> http://git.linuxtv.org/v4l-utils.git

Hmm, I get errors when I attempt to clone this.

Regards,

	Hans
 
> Note, it would be good to have some place at linuxtv.org to host the
> tarbals, if someone could help me set that up that would be great.
> 
> Regards,
> 
> Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
