Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZK2Q0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 11:26:32 -0500
Message-ID: <4B12A275.3070902@redhat.com>
Date: Sun, 29 Nov 2009 17:33:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?N=E9me?= =?ISO-8859-1?Q?th_M=E1rton?=
	<nm127@freemail.hu>
Subject: Re: [PATCH] gspca main: reorganize loop
References: <4B124BDF.50309@freemail.hu>	<20091129113834.6b47767a@tele>	<4B1258D2.7060706@freemail.hu> <20091129131511.2bb26f2b@tele>
In-Reply-To: <20091129131511.2bb26f2b@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/29/2009 01:15 PM, Jean-Francois Moine wrote:
> On Sun, 29 Nov 2009 12:19:46 +0100
> Németh Márton<nm127@freemail.hu>  wrote:
>
>> Is there any subdriver where the isoc_nego() is implemented? I
>> couldn't find one. What would be the task of the isoc_nego()
>> function? Should it set the interface by calling usb_set_interface()
>> as the get_ep() does? Should it create URBs for the endpoint?
>>
>> Although I found the patch where the isoc_nego() was introduced
>> ( http://linuxtv.org/hg/v4l-dvb/rev/5a5b23605bdb56aec86c9a89de8ca8b8ae9cb925 )
>> it is not clear how the "ep" pointer is updated when not the
>> isoc_nego() is called instead of get_ep() in the current
>> implementation.
>
> Hello Hans,
>
> This function (isoc_nego) was added to fix the Mauro's problem with the
> st6422. Was this problem solved in some other way, or is the fix still
> waiting to be pulled?
>

The fix is still waiting to be pulled, or actually to be made working :|

First a quick summary of the need for the isoc_nego() function
(and to only call get_ep() once). Some cams, at least those based on stv06xx
bridges, have only 1 alt setting, but they have a register which allows
one to tell it to send isoc frames which are never bigger then the value
set in the register. I've tested this and it works as advertised,
when you create isoc urbs with a size < wMaxPacketSize, then normally
you will get -EMSGSIZE errors (iirc) as the camera sends isoc frames,
larger then the buffers in the isoc urbs created, but if you then write the
size you created the isoc urbs with to the register in question, things
will work. So this works as expected.

The problem is that the usb "scheduler" which checks the bandwidth constrains
will always use wMaxPacketSize to check if there is enough bandwidth instead
of the actual packet size of the isoc packets. So although I have a patch
implementing the isoc_neg call for stv06xx cams, it does not actually help
as although it is scaling back the bandwidth needed, the usb core does not
see this and keeps returning -ENOSPC.

After finding out about this I ran out of time. This reminds me that I need to
send a message about this to the usb mailing list. I will do so now, and
then we will see what will come from this.

Regards,

Hans
