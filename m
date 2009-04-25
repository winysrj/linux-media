Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3P9pCoW003468
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 05:51:12 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [217.30.184.167])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3P9oune001018
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 05:50:56 -0400
Message-ID: <49F2DCFA.7030809@iki.fi>
Date: Sat, 25 Apr 2009 12:50:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <49D644CD.1040307@powercraft.nl>	<49D64E45.2070303@powercraft.nl>	<49DC5033.4000803@powercraft.nl>	<49F1B2A4.3060404@powercraft.nl>
	<49F20259.1090302@iki.fi>	<49F2C312.4030808@powercraft.nl>
	<49F2C710.2000906@iki.fi> <49F2CFD5.5070101@powercraft.nl>
	<49F2D25B.80801@iki.fi> <49F2DB50.5090003@powercraft.nl>
In-Reply-To: <49F2DB50.5090003@powercraft.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: one dvb-t devices not working with mplayer the other is, what
 is going wrong?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 04/25/2009 12:43 PM, Jelle de Jong wrote:
> Any ideas, does mplayer works directly with dvb on your side so without tzap:
> $ /usr/bin/mplayer -dvbin timeout=10 dvb://"3FM(Digitenne)"

Because mplayer does not wait enough for demodulator lock. It is set to 
800ms in code (if I remember correctly). I don't know what timeout=10 
sets, but I think it could be override value got from demod and if this 
timeout=10 is less than 800ms got from demod we could have a problem. 
Try to remove it (uses demod value?) or increase it.

regards
Antti
-- 
http://palosaari.fi/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
