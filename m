Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9PGVwRY012361
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 12:31:58 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9PGVkGk024290
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 12:31:47 -0400
Message-ID: <490349F1.9000100@xnet.com>
Date: Sat, 25 Oct 2008 11:31:45 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
References: <200810231238.34963.vanessaezekowitz@gmail.com>
In-Reply-To: <200810231238.34963.vanessaezekowitz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld 120 IR control?
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



Vanessa Ezekowitz wrote:
> (forgot to cc the list)
> 
> On Thursday 16 October 2008 5:45:42 pm Hermann Pitton wrote:
> 
>>>> Interesting, I can not read any writing on that chip.  All I see is a 
>>>> green dot probably identifying pin 1.  If this is a common i2c 
>>>> controller - why bother? Or are the KS003 and KS007 custom chips?
> 
> The chip on  my card has been chemically wiped I think - there aren't any scratches or scrapes on it.  Despite my best efforts with multiple light sources, I still can't identify it.  In the meantime, I wrote to Kworld asking them to identify the chip in question, or to provide some kind of details allowing us to communicate with whatever device handles the remote control.  They responded a few days ago indicating that they would pass my request on to the engineering department.  That department has not responded yet.
> 

Thanks for trying Vanessa.

If none of the developers have this board (Kworld - 120 ATSC/NTSC tuner 
card) to play with ...  well, if someone would give me "turn-by-turn" 
(airport talk for "I'm sitting on the tarmac, how do I get to the gate) 
directions I can try to probe the card to find out more.  I just don't 
have the time to research the tools to do the job and how to go about 
using them.  My board is in a Mythtv SBE Debian/Unstable system and is 
working great if only to capture ATSC OTA broadcasts (i.e. no IR control 
and no NTSC).

...thanks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
