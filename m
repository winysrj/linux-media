Return-path: <linux-media-owner@vger.kernel.org>
Received: from 203-42-208-117.tpips.telstra.com ([203.42.208.117]:39847 "EHLO
	starnewsgroup.com.au" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0ETA0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 20:26:05 -0400
Message-ID: <4BF594FF.30505@starnewsgroup.com.au>
Date: Fri, 21 May 2010 06:01:03 +1000
From: Nathan Metcalf <nmetcalf@starnewsgroup.com.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hermann pitton <hermann-pitton@arcor.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek DVT1000S W/ Phillips saa7134
References: <4BF583EB.7080505@starnewsgroup.com.au> <1274311695.5829.6.camel@pc07.localdom.local>
In-Reply-To: <1274311695.5829.6.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hermann,
Does this mean I need to apply that patch you linked to me? Then 
recompile the module and re-insert?

Regards,
Nathan

On 20/05/10 09:28, hermann pitton wrote:
> Hi Nathan,
>
> Am Freitag, den 21.05.2010, 04:48 +1000 schrieb Nathan Metcalf:
>    
>> Hey Guys,
>> I hope this is the correct place, I am trying to get a LEADTEK DVT1000S HD Tuner card working in Ubuntu (Latest)
>> When I load the saa7134_dvb kernel module, there are no errors, but /dev/dvb is not created.
>>
>> I have tried enabling the debug=1 option when loading the module, but don't get any more useful information.
>>
>> Can someone please assist me? Or direct me to the correct place?
>>
>> Regards,
>> Nathan Metcalf
>>
>>      
> there was some buglet previously, but the card is else supported since
> Nov. 01 2009 on mercurial v4l-dvb and later kernels.
>
> http://linuxtv.org/hg/v4l-dvb/rev/855ee0444e61b8dfe98f495026c4e75c461ce9dd
>
> Support for the remote was also added.
>
> Cheers,
> Hermann
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> --
> This message was scanned by ESVA and is believed to be clean.
> To report this message as spam - click the link below
> http://mailscan.starnewsgroup.com.au/cgi-bin/learn-msg.cgi?id=EC83EC8003.3A3A3
>
>    
