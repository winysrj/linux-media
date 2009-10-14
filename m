Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:38499 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbZJNPD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 11:03:26 -0400
Received: by yxe26 with SMTP id 26so5418095yxe.4
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 08:02:49 -0700 (PDT)
Message-ID: <4AD5E813.2070406@gmail.com>
Date: Wed, 14 Oct 2009 12:02:43 -0300
From: Guilherme Longo <grlongo.ireland@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: libv4l does not work! 
References: <4ACDF829.3010500@xfce.org>	<37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	<4ACDFED9.30606@xfce.org>	<829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	<4ACE2D5B.4080603@xfce.org>	<829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>	<4ACF03BA.4070505@xfce.org>	<829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>	<4ACF714A.2090209@xfce.org>	<829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>	<4AD5D5F2.9080102@xfce.org> <20091014093038.423f3304@pedra.chehab.org> <4AD5EEA0.2010709@xfce.org>
In-Reply-To: <4AD5EEA0.2010709@xfce.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do we need include any other header file than

libv4l2.h
libv4lconvert.h

to get libv4l working?

I read Hans saying that:

Just replace open("dev/video0", ...) with v4l2_open("dev/video0", ...), 
ioctl with v4l2_ioctl, etc. libv4l2 will then do conversion of any known 
(webcam) pixelformats to bgr24 or yuv420.

But I am getting undefined reference to 'v4l2_open' and 'v4l2_ioctl'.
Can I get some help?

regards!
Guilherme Longo
