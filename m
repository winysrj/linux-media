Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50799 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab2FGVxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 17:53:52 -0400
Received: by eaak11 with SMTP id k11so537680eaa.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2012 14:53:51 -0700 (PDT)
MIME-Version: 1.0
From: cheng renquan <crquan@gmail.com>
Date: Thu, 7 Jun 2012 14:53:30 -0700
Message-ID: <CAH5vBdLJD1nvxK4eE5uP6cB-PwMQ+9CCUV0GQb0YBa1ZLxKxZg@mail.gmail.com>
Subject: what are the media tuners / can we make them not default selected?
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

when I was compiling default minimum kernel for my laptop,
I started with "make x86_64_defconfig" then menuconfig
to enable only a few kernel features or device drivers those I have,
including the USB_VIDEO_CLASS for webcam;
with this I enabled VIDEO_DEV but disable DVB_CORE;

till recently I found that also chosen those media tuner modules,

$ grep MEDIA_TUNER /boot/config
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

as I understand, MEDIA_TUNER is for some tv adapters but I don't have
such hardware,
to disable them I need to enable MEDIA_TUNER_CUSTOMISE, then
a menu "Customize TV tuners" becomes visible then I need to enter that
menu and disable all the tuners one-by-one;
this looks not convenient,


config MEDIA_TUNER
        tristate
        default VIDEO_MEDIA && I2C
        depends on VIDEO_MEDIA && I2C
        select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE && EXPERIMENTAL
        select MEDIA_TUNER_TEA5767 if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_TDA9887 if !MEDIA_TUNER_CUSTOMISE
        select MEDIA_TUNER_MC44S803 if !MEDIA_TUNER_CUSTOMISE

menu "Customize TV tuners"
        visible if MEDIA_TUNER_CUSTOMISE

-- 
cheng renquan (程任全)
