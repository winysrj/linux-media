Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADIcBg5007919
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 13:38:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADIBkZ0022062
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 13:11:46 -0500
Date: Thu, 13 Nov 2008 16:11:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@pobox.com>
Message-ID: <20081113161137.11529bf0@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0811131135290.27554@cnc.isely.net>
References: <20081113152622.6f6b7092@pedra.chehab.org>
	<Pine.LNX.4.64.0811131135290.27554@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: isely@isely.net, Video <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH] missdetection on pvrusb2
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

On Thu, 13 Nov 2008 11:46:07 -0600 (CST)
Mike Isely <isely@isely.net> wrote:

> This is logic that hasn't changed in a LONG time in the pvrusb2 driver.  
> So why is it only now becoming a problem?  Did something change on the 
> tvaudio side?

The only change at tvaudio side I'm aware of are the conversion to the new i2c mode.

> I see in the diff below that tvaudio's 
> chip_legacy_probe() function is going to return true for any adapter 
> tagged with I2C_CLASS_TV_ANALOG.  Is that really (!) right?  That seems 
> a bit overbroad.

This is the common code on all V4L i2c devices.

>  Unfortunately I'm at a disadvantage right now and am 
> unable to look at the surrounding full source.  But I certainly will 
> tonight.  Perhaps there is additional filtering elsewhere.
> 
> The above question not withstanding, the patch is otherwise harmless to 
> the pvrusb2 driver.  Mike is right in that tvaudio should never actually 
> be needed.  But before I ack this let me look at this code a little 
> further.  I'd like to know why this has just now become an issue, before 
> pasting over it with this patch.  I will do that tonight (about 10 hours 
> from now).  So bear with me a little bit.

You should notice that the issue only happened when the user compiled tvaudio
(and pvrusb2) at vmlinuz, instead of being a module.

When tvaudio is a module, as pvrusb2 don't request the module, this bug doesn't happen.

Also, with the older pvrusb2 (I tested with model 29032), the i2c address 0x84
is not used.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
