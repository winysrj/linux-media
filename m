Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34670 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993174AbbEEO0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 10:26:10 -0400
Received: by wicmx19 with SMTP id mx19so102452799wic.1
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 07:26:09 -0700 (PDT)
Message-ID: <5548D2FF.3050100@gmail.com>
Date: Tue, 05 May 2015 15:26:07 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com,
	"crope@iki.fi >> Antti Palosaari" <crope@iki.fi>,
	"patrick.boettcher@posteo.de >> Patrick Boettcher"
	<patrick.boettcher@posteo.de>
Subject: DVBv5 qos/stats driver implementation
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro/Antti,

Myself and Patrick are currently in the process of bringing an old out 
of tree frontend driver into shape for inclusion, and one of the issues 
raised by Mauro was the requirement for the new DVBv5 stats method. I've 
noticed there seems to be two different ways of going around this - one 
is to run through the collection and cache filling process during the 
calls to read_status (as in dib7000p/dib8000p), and the other is to poll 
independently every couple of seconds via schedule_delayed_work (as in 
af9033, rtl2830/2832).

Is there any reason for the two different ways - is it just a coding 
preference or is there some specifics to how these frontends need to be 
implemented?

Thanks,

Jemma.


