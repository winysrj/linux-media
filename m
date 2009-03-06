Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:60963
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbZCFPsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 10:48:11 -0500
Message-ID: <49B145BC.4020405@nildram.co.uk>
Date: Fri, 06 Mar 2009 15:48:12 +0000
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: Pierre Gronlier <ticapix@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: TT S2-3200 and CAMs
References: <49AE8BB3.3010501@nildram.co.uk> <49AEB91C.6010804@gmail.com>
In-Reply-To: <49AEB91C.6010804@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pierre Gronlier wrote:
> Lou Otway wrote:
>   
>> Hi,
>>
>> I've been testing the TT S2-3200 card and while it performs well for FTA
>> services I have been unable to get it working with encrypted services using
>> the CI slot.
>>
>> With VLC I am able to tune to the transponder and pick up all the services
>> but they are not decrypted, unencrypted services work fine.
>>
>> Using a DVB-S card with CI I am able to tune successfully, proving the CAMs
>> are valid. This leads me to believe there may be a problem with the drivers
>> for the S2-3200.
>>
>> Has anyone managed to get CAMs working with this card?
>>
>>     
>
> yes, I manage to decrypt a entire dvb-s transponder using a powercam and
> mumudvb for streaming channels.
>
> I'm using the v4l-dvb driver from the hg repository.
>
> For mumudvb, I made a checkout of the git repository
> http://mumudvbgit.braice.net/mumudvb.git and compiled the source with
> LIBDVBEN50221=1 make (you need the dvb-apps to be installed)
>
>
> But using this card, I didn't manage to lock on my second lnd head, so I
> manage to lock on astra 19.2E but not on hotbird 13.0E.
>
>
> Pierre
>   

Thanks, I managed to get this card working.

Lou
