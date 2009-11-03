Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38823 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbZKCBpA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 20:45:00 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N58SG-0004bP-6d
	for linux-media@vger.kernel.org; Tue, 03 Nov 2009 02:45:04 +0100
Received: from 78-105-205-147.zone3.bethere.co.uk ([78.105.205.147])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 02:45:04 +0100
Received: from topper.doggle by 78-105-205-147.zone3.bethere.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 02:45:04 +0100
To: linux-media@vger.kernel.org
From: TD <topper.doggle@googlemail.com>
Subject: Re: [linux-dvb] Struggling with Astra 2D (Freesat) / Happauage
 Nova-HD-S2
Date: Tue, 3 Nov 2009 00:11:22 +0000 (UTC)
Message-ID: <hcnsfa$v70$1@ger.gmane.org>
References: <hcnd9s$c1f$1@ger.gmane.org> <20091102231735.63fd30c4@bk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-dvb@linuxtv.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2009-11-02, Goga777 <goga777@bk.ru> wrote:
> Приветствую, TD
>
> you have to use scan-s2
> http://mercurial.intuxication.org/hg/scan-s2

Hi, and thanks for your quick reply.

I tried it but no better:
<snip>
initial transponder DVB-S  12692000 V 19532000 1/2 AUTO AUTO
initial transponder DVB-S2 12692000 V 19532000 1/2 AUTO AUTO
----------------------------------> Using DVB-S
>>> tune to: 11720:hC34S0:S0.0W:29500:
DVB-S IF freq is 1120000
WARNING: >>> tuning failed!!!
>>> tune to: 11720:hC34S0:S0.0W:29500: (tuning failed)

and the channels.conf was no better than before - it didn't include *one* BBC
channel, for example.

>
> or
>
> dvb2010 scan
> http://hg.kewl.org/dvb2010/

Once I got it working, same:
Astra 2A/2B/2D/Eurobird 1 (28.2E) 10714 H DVB-S QPSK 22000 5/6 ONID:0 TID:0
AGC:0% SNR:0% 
    Can't tune

Astra 2A/2B/2D/Eurobird 1 (28.2E) 10729 V DVB-S QPSK 22000 5/6 ONID:0 TID:0
AGC:0% SNR:0% 
    Can't tune

Where do I go from here?
-- 
TD

