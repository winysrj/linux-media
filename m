Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.li-life.net ([195.225.200.6]:1231 "EHLO mail.li-life.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1H2RYB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 13:24:01 -0400
Message-ID: <4E5BCB20.8060703@kaiser-linux.li>
Date: Mon, 29 Aug 2011 19:23:44 +0200
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: DD Cine CT DVB-C/T
References: <4E567CB8.5060409@kaiser-linux.li>
In-Reply-To: <4E567CB8.5060409@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2011 06:47 PM, Thomas Kaiser wrote:
> Hi
>
> Which modules do I have to build and install to use this card (DD Cine 
> CT DVB-C/T Rev. V6).
>
> I checkd out:
> hg clone http://linuxtv.org/hg/~endriss/media_build_experimental
>
> I would like to build only the needed modules. What do I have to 
> select in "make menuconfig"?
>
> Regards, Thomas
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks like I took the wrong source...

static const struct pci_device_id ddb_id_tbl[] __devinitdata = {
     DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
     DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
     DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
     DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus),
     DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
     /* in case sub-ids got deleted in flash */
     DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
     {0}
};

My card has the _subdev 0x0030!

Where can I find the right source code for this card?

I am ready to help developing and testing.

Thomas

