Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.aswsp.com ([193.34.35.150]:40216 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbbCPRsp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 13:48:45 -0400
Message-ID: <5507177A.8060200@parrot.com>
Date: Mon, 16 Mar 2015 18:48:42 +0100
From: =?UTF-8?B?QXVyw6lsaWVuIFphbmVsbGk=?= <aurelien.zanelli@parrot.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: Dynamic video input/output list
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I'm looking to enhance video input/output enumeration support in
GStreamer using VIDIOC_ENUMINPUT/VIDIOC_ENUMOUTPUT ioctls and after some
discussions we wonder if the input/output list can change dynamically at
runtime or not.

So, is v4l2 allow this input/output list to be dynamic ?

Cheers
-- 
Aurélien Zanelli
