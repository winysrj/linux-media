Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81Kv0mv016421
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 16:57:00 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81KulCP003730
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 16:56:48 -0400
Message-ID: <48BC59C8.9050101@hhs.nl>
Date: Mon, 01 Sep 2008 23:08:24 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: JoJo jojo <onetwojojo@gmail.com>
References: <48B7D198.60505@hhs.nl>
	<226dee610809011219h4088a062k77a2d0ac1acbc047@mail.gmail.com>
In-Reply-To: <226dee610809011219h4088a062k77a2d0ac1acbc047@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: gspca-sonixb and sn9c102 produce incompatible
	V4L2_PIX_FMT_SN9C10X
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

JoJo jojo wrote:
> On Fri, Aug 29, 2008 at 4:08 PM, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
>> Hi all,
>> 1) Fix the gspca driver and libv4l to produce / expect BGGR bayer inside the
>> V4L2_PIX_FMT_SN9C10X data, making gspca compatible with the already released
>> in an official kernel sn9c102 driver. The downside of this is that we loose
>> all the testing done with gspca (both v1 and v2) with the current gspca
>> settings but given that windows uses the sn9c102 settings I don't expect
>> much
>> of a problem from this (and I can test the new settings for 3 of the 7
>> supported sensors).
>>
> 
> 
> What are the other 4 USB ids of sensors that you can't test yourself?
> Maybe we can help.
> 

We could use testing for the following usb-id's:

         {USB_DEVICE(0x0c45, 0x6007), SB(TAS5110, 101)}, /* TAS5110D */
         {USB_DEVICE(0x0c45, 0x6009), SB(PAS106, 101)},
         {USB_DEVICE(0x0c45, 0x600d), SB(PAS106, 101)},
         {USB_DEVICE(0x0c45, 0x6019), SB(OV7630, 101)},
         {USB_DEVICE(0x0c45, 0x6024), SB(TAS5130CXX, 102)},
         {USB_DEVICE(0x0c45, 0x6025), SB(TAS5130CXX, 102)},
         {USB_DEVICE(0x0c45, 0x6028), SB(PAS202, 102)},
         {USB_DEVICE(0x0c45, 0x6029), SB(PAS106, 102)},
         {USB_DEVICE(0x0c45, 0x602c), SB(OV7630, 102)},
         {USB_DEVICE(0x0c45, 0x602d), SB(HV7131R, 102)},
         {USB_DEVICE(0x0c45, 0x602e), SB(OV7630, 102)},
         {USB_DEVICE(0x0c45, 0x60af), SB(PAS202, 103)},

Which should currently be supported, we are also interested in any cams with a 
usb-id matching: 0c45:60?? or 0c45:61??, some may just need to right entry 
added to the usb-id table, while others may require adding some code.

Thanks & Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
