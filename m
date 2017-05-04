Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52680
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751958AbdEDMLy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 08:11:54 -0400
Date: Thu, 4 May 2017 09:11:47 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Reinhard Speyerer <rspmn@arcor.de>
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
Message-ID: <20170504091147.3f3edc16@vento.lan>
In-Reply-To: <00937473-581c-ecf8-58c6-616a78aa37c5@googlemail.com>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
        <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
        <20170503095303.71cf3a75@vento.lan>
        <20170503193318.07ddf143@vento.lan>
        <00937473-581c-ecf8-58c6-616a78aa37c5@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 4 May 2017 09:55:04 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello Mauro,
> 
> On 04.05.17 00:33, Mauro Carvalho Chehab wrote:
> > Em Wed, 3 May 2017 09:53:03 -0300
> > Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:  
> >> Em Tue, 2 May 2017 22:30:29 +0200
> >> Gregor Jasny <gjasny@googlemail.com> escreveu:  
> >>> I just used your patch and another to hopefully fix
> >>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
> >>>
> >>> But I'm a little bit hesitant to merge it to v4l-utils git without
> >>> Mauros acknowledgement.  
> 
> >> Patches look correct, but the T2 parser has a more serious issue that
> >> will require breaking ABI/API compatibility.  
> 
> > I'll cherry-pick the corresponding patches to the stable branch.  
> 
> Reinhard, could you please test the latest patches on
> https://git.linuxtv.org/v4l-utils.git/log/?h=stable-1.12
> 
> If they work for you, I'd release a new stable version and upload it to 
> Debian Sid afterwards.

I found one additional bug there, at the code that handles subcells.

Fix applied. Reinhard/Clemens, if you find some channel that use
subcells on this descriptor and/or tfs_flag == 1, it would be really cool
if you could store ~60 seconds of the transponder and send it to me, as it
would allow me to have a testing stream. With that, I can input the stream
on my RF generator and test if this is parsed well with libdvbv5,
dvbv5-tools and Kaffeine.

In order to record 60 seconds for the full transponder, after generating
the channel scan, you can do (to record a channel named "RTL HD"):

	$ dvbv5-zap -c dvb_channel.conf 'RTL HD' -r -P -t60 -o mychannel.ts

This will produce a big file, so you'll likely need to put it on
some place like dropbox/google drive and pass me the link via
a private e-mail.

-

At the master branch, I just added the logic to fully parse the
cell and subcell IDs. I also added (on both stable-1.2 and master)
a code that will translate guard_interval, SISO/MISO, bandwidth
and transmission mode to the corresponding strings for the bitfield
values.

With those changes, on "master" branch, it will now list the full
content of the descriptor at the NIT table:

NIT
| table_id         0x40
| section_length      135
| one                 3
| zero                1
| syntax              1
| transport_stream_id 12352
| current_next        1
| version             9
| one2                3
| section_number      0
| last_section_number 0
| desc_length   45
|        0x40: network_name_descriptor
|           network name: 'MEDIA BROADCAST'
|        0x4a: linkage_descriptor
|           40 71 21 14 42 4c 09 12  60 74 8d 0e 00 f6 00 05   @q!.BL..`t......
|           00 00 01 68 00 00 00 07  07 00                     ...h......
|- transport 4061 network 2114
|        0x7f: extension_descriptor
|           descriptor T2_delivery_system_descriptor type 0x04
|           plp_id                    0
|           system_id                 7766
|           tfs_flag                  0
|           other_frequency_flag      0
|           transmission_mode         32K (5)
|           guard_interval            1/16 (1)
|           reserved                  3
|           bandwidth                 8000000
|           SISO MISO                 SISO
|           Cell ID                   0x6101
|              centre frequency[0]    64200000
|           Cell ID                   0x0457
|              centre frequency[0]    65000000
|           frequency[0]              64200000
|           frequency[1]              65000000
|        0x41: Unknown descriptor
|           03 01 1f 42 41 1f 42 42  1f 42 43 1f 42 44 1f 42   ...BA.BB.BC.BD.B
|           45 1f                                              E.
|- transport 4071 network 2114
|        0x7f: extension_descriptor
|           descriptor T2_delivery_system_descriptor type 0x04
|           plp_id                    1
|           system_id                 7766
|           tfs_flag                  0
|           other_frequency_flag      0
|           transmission_mode         32K (5)
|           guard_interval            1/16 (1)
|           reserved                  3
|           bandwidth                 8000000
|           SISO MISO                 SISO
|           Cell ID                   0x0457
|              centre frequency[0]    72200000
|           frequency[0]              72200000
|        0x41: Unknown descriptor
|           42 4c 0c 42 80 01                                  BL.B..
|_  2 transports


Thanks,
Mauro
