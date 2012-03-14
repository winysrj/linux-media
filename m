Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.interworx.nl ([93.190.137.248]:42035 "EHLO
	mail.interworx.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab0DVSHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 14:07:51 -0400
Received: from [62.45.235.101] ([62.45.235.101])
	by mail.interworx.nl (Kerio MailServer 6.6.2)
	for linux-media@vger.kernel.org;
	Wed, 14 Mar 2012 16:53:04 +0100
To: linux-media@vger.kernel.org
From: "Hans van den Bogert" <gandalf@unit-westland.nl>
Subject: anysee e30 suspend->resume causes wrong profiling of card.
Message-ID: <20120314155304.c347fb58@mail.interworx.nl>
Date: Wed, 14 Mar 2012 16:53:04 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The anysee driver works correctly from cold boot and reinsertion of the device, however, after a suspend resume cycle (S3),  the device suddenly is initated as dvb-t as where it was dvb-c before. Yes this is a combo device, so dvb T and C, but why does the profiling in anysee.c not handle this case? Obviously the following snippet produces a false positive on warm boot and resume:


/* Zarlink ZL10353 DVB-T demod inside of Samsung DNOS404ZH103A NIM */
        adap->fe = dvb_attach(zl10353_attach, &anysee_zl10353_config,
                              &adap->dev->i2c_adap);
        if (adap->fe != NULL) {
                state->tuner = DVB_PLL_THOMSON_DTT7579;
                info("mine: case 2");
                return 0;
        }

I've looked through the rest of the code and by no means am I a developer but, isn't the problem that on warm boots the register of the anysee device doesn't hold the right value in combination with a combo device? because in all the other cases when profiling for different kind of device like the e30c the register is put in a different state before probing for the demuxer.

In the meantime I have commented out the above snippet, which results in a works-for-me. But it isn't a nice solution for the average/new linux user wanting to build a htpc with a anysee combo device.

Tested with ubuntu-lucid module, further tested/compiled with the HG repo.

ps I'm new with mailing lists, is this the right place to post for the anysee driver?
