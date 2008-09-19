Return-path: <video4linux-list-bounces@redhat.com>
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JDt2E9019627
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 09:55:02 -0400
Message-ID: <48D3306B.4060001@hhs.nl>
Date: Fri, 19 Sep 2008 06:54:03 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
References: <62e5edd40809180002t248de932g3c3515bf5081993c@mail.gmail.com>
In-Reply-To: <62e5edd40809180002t248de932g3c3515bf5081993c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: m560x-driver-devel <m560x-driver-devel@lists.sourceforge.net>,
	video4linux-list@redhat.com
Subject: Re: [PATCH][RFC] Add support for the ALi m5602 usb bridge webcam
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

Erik Andrén wrote:
> Hi,
> I'm proud to announce the following patch adding support for the ALi m5602
> usb bridge connected to several different sensors.
> This driver has been brewing for a long time in the m560x.sf.net project and
> exists due to the hard work of many persons.
> 
> libv4l is needed in order to gain support for multiple pixelformats.
> 
> The patch should apply against the latest v4l-dvb hg tree.
> 
> Thanks for any feedback,
> Erik
>

Hi Erik,

Thanks for doing this, unfortunately the driver which you used as a 
template to start from has various issues (not allowing multiple opens 
for one, interpreting the v4l2 API in interesting ways in other places).

Besides that there is lot of code duplication between isoc mode usb webcams.

I would kindly like to ask you to consider porting the m5602 driver to 
the gspca framework, which provides a generic framework for isoc webcams 
and takes a lot of stuff out of the driver and into a more generic 
framework (like try_fmt mode negatiation, isoc mode setup and handling, 
frame buffer management, etc.).

gspca is in the current 2.6.27 kernels, if you look under
drivers/media/video/gspca you will see drivers for a lot of different 
webcams there, you could for example take the pac207 driver as an 
example, strip it empty and then copy and paste the relevant part of 
your driver to there.

I will help you in anyway I can.

Does this sound like a plan?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
