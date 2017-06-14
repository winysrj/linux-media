Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752353AbdFNNIK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 09:08:10 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4AEC123E6CB
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 13:08:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4162E949C6
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 13:08:10 +0000 (UTC)
Received: from zmail22.collab.prod.int.phx2.redhat.com (zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 37D531841C42
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 13:08:10 +0000 (UTC)
Date: Wed, 14 Jun 2017 09:08:10 -0400 (EDT)
From: Jaroslav Skarvada <jskarvad@redhat.com>
To: linux-media@vger.kernel.org
Message-ID: <1544403709.22095603.1497445690011.JavaMail.zimbra@redhat.com>
In-Reply-To: <ff6c7a4d494155764eb9b8aca0c90eb4@iki.fi>
References: <20170609174644.8735-1-jskarvad@redhat.com> <ff6c7a4d494155764eb9b8aca0c90eb4@iki.fi>
Subject: Re: [PATCH] dvb-usb-af9035: load HID table
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



----- Original Message -----
> Hello
> 
> Jaroslav Škarvada kirjoitti 2017-06-09 20:46:
> > Automatically load sniffed HID table from Windows driver if
> > USB_VID_ITETECH:USB_PID_ITETECH_IT9135_9006 device is present (e.g.
> > Evolveo
> > Mars) or if module parameter force_hid_tab_load is set.
> 
> There is few issues I don't like this approach. Mostly that module
> parameter to select HID table. There is existing solution to select
> remote controller, it is ir-keytable and it should be used rather than
> defining device specific module parameter.
> 
> If you look that HID table you could see there is 4 bytes NEC code and 3
> bytes HID code. Remote controller seems to have 34 keys. Remote
> controller address bytes are 0x02bd, grepping existing remote controller
> keytables it could be Total Media In Hand remote controller
> (rc-total-media-in-hand.c). If not, then defining new keytable is
> needed.
> 
> I did some research about issue and found 2 better solutions.
> 1) Configure HID table dynamically. Remote controller keytable has some
> needed information, but those KEY_* events needed to be translated to
> HID codes somehow.
> 2) Kill HID and then use CMD_IR_GET to get remote controller scancodes
> by polling.
> 
> Solution 1 sounds most correct. No need to poll and decode by sw as hw
> does all the job. But it is most hardest to implement, I am not aware if
> anyone has done it yet.
> 
> regards
> Antti
> 
> 
> --
> http://palosaari.fi/
> 

Hi,

thanks for info. General approach is usually better than device specific
hacks, but it looks like longer run. Unfortunately I returned the device to
the original owner, so I will be probably unable to help with it more. But
the problem needs to be addressed, the state when the remote isn't working
isn't good

thanks & regards

Jaroslav
