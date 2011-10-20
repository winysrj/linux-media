Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56915 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1JTQYO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 12:24:14 -0400
Message-ID: <4EA04B2A.6090904@iki.fi>
Date: Thu, 20 Oct 2011 19:24:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.2] Anysee
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:

   [media] media: DocBook: Fix trivial typo in Sub-device Interface 
(2011-09-27 09:14:58 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git anysee

Antti Palosaari (7):
       tda18212: add DVB-T2 support
       anysee: add support for Anysee E7 T2C
       anysee: I2C gate control DNOD44CDH086A tuner module
       anysee: CI/CAM support
       anysee: fix fronted pointers due to merge conflict
       anysee: add control message debugs
       anysee: fix style issues

  drivers/media/common/tuners/tda18212.c |   49 +++-
  drivers/media/common/tuners/tda18212.h |    4 +
  drivers/media/dvb/dvb-usb/Kconfig      |    1 +
  drivers/media/dvb/dvb-usb/anysee.c     |  418 
+++++++++++++++++++++++++++-----
  drivers/media/dvb/dvb-usb/anysee.h     |    6 +
  5 files changed, 404 insertions(+), 74 deletions(-)


-- 
http://palosaari.fi/
