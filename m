Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.techmunk.com ([209.141.61.243]:46501 "EHLO
	mail.techmunk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbCMLCh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:02:37 -0400
Message-ID: <5502C3B2.407@techmunk.com>
Date: Fri, 13 Mar 2015 21:02:10 +1000
From: Christian Dale <kernel@techmunk.com>
Reply-To: Christian Dale <kernel@techmunk.com>
MIME-Version: 1.0
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rtl28xxu: add [0413:6f12] WinFast DTV2000 DS
 Plus
References: <1425878341-3037-1-git-send-email-kernel@techmunk.com> <20150313100731.GA66976@shambles.windy>
In-Reply-To: <20150313100731.GA66976@shambles.windy>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I should note, that patch does not work for the 3.18 kernel.
In the driver, rtl2832u_props was updated to rtl28xxu_props in commit 
723abfd787f7cccaff89036b8aa14f56a2f7a11a. So you'd need to invert that 
change for the patch to work against 3.18.

On 13/03/15 20:07, Vincent McIntyre wrote:
> On Mon, Mar 09, 2015 at 03:19:01PM +1000, Christian Dale wrote:
>> Add Leadtek WinFast DTV2000DS Plus device based on Realtek RTL2832U.
>>
>> I have not tested the remote, but it is the Y04G0051 model.
>>
> Thanks for doing this Christian. I have one of these cards also, 0x6f12.
> I wrote the same patch some time ago and it is not working for me.
> Can you give a few details of what kernel you tested on etc?
>
> I am testing on ubuntu 14.04 LTS
> [    0.000000] Linux version 3.13.0-45-generic (buildd@kissel) (gcc
> version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #74-Ubuntu SMP Tue Jan 13
> 19:37:48 UTC 2015 (Ubuntu 3.13.0-45.74-generic 3.13.11-ckt13)
>
>
> The symptom I have is when I try to tune with 'scan'
> from dvb-apps, the program wedges and I get this in dmesg:
> [  163.138982] fc0013: fc0013_set_params: failed: -22
> [  164.246233] fc0013: fc0013_set_params: failed: -22
> [  165.167758] fc0013: fc0013_set_params: failed: -22
> [  166.250280] fc0013: fc0013_set_params: failed: -22
> [  167.196580] fc0013: fc0013_set_params: failed: -22
> [  168.286208] fc0013: fc0013_set_params: failed: -22
> ...
>
> kind regards
> Vince

