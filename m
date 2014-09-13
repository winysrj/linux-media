Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35972 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaIMAhP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 20:37:15 -0400
Message-ID: <541391B9.4070708@osg.samsung.com>
Date: Fri, 12 Sep 2014 18:37:13 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 ioctls
References: <54124BDC.3000306@osg.samsung.com> <5412A9DB.8080701@xs4all.nl> <20140912121950.7edfee4e.m.chehab@samsung.com>
In-Reply-To: <20140912121950.7edfee4e.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro/Hans,

Thanks for both for your replies. I finally have it working with
the following:

S_INPUT
S_OUTPUT
S_MODULATOR
S_TUNER
S_STD
S_FREQUENCY
S_HW_FREQ_SEEK
S_FMT
 - get tuner in shared mode and hold it
 - i.e return with tuner held

STREAMON
 - get tuner in shared mode and hold it
 - i.e return with tuner held
STREAMOFF
 - put tuner (get is done in STREAMON)

QUERYSTD
G_TUNER (au0828 does tuner init in its g_tuner ops)
 - get tuner in shared mode and hold it
 - service request
 - put tuner

With these changes now I have digital stream not get
disrupted as soon as xawtv starts. I am working through
issues related to unbalanced nature of tuner holds in
analog mode.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
