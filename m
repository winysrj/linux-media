Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF2esnS001000
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 21:40:54 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBF2efx1011469
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 21:40:41 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2161675wfc.6
	for <video4linux-list@redhat.com>; Sun, 14 Dec 2008 18:40:41 -0800 (PST)
Message-ID: <aec7e5c30812141840v50214099n43891d18f5b9acfa@mail.gmail.com>
Date: Mon, 15 Dec 2008 11:40:41 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812132244130.10954@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
	<20081210074450.5727.83002.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0812132244130.10954@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 02/03] sh_mobile_ceu: add NV12 and NV21 support
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

On Sun, Dec 14, 2008 at 6:52 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 10 Dec 2008, Magnus Damm wrote:
>> This patch adds NV12/NV21 support to the sh_mobile_ceu driver.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> ---
>>
>>  drivers/media/video/sh_mobile_ceu_camera.c |  114 ++++++++++++++++++++++++----
>>  1 file changed, 99 insertions(+), 15 deletions(-)
>>
>> --- 0031/drivers/media/video/sh_mobile_ceu_camera.c
>> +++ work/drivers/media/video/sh_mobile_ceu_camera.c   2008-12-10 13:09:43.000000000 +0900
>> @@ -158,6 +160,9 @@ static void free_buffer(struct videobuf_
>>
>>  static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>>  {
>> +     struct soc_camera_device *icd = pcdev->icd;
>> +     unsigned long phys_addr;
>
> dma_addr_t

Yeah, good plan.

>> +
>>       ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~1);
>>       ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & 0x0317f313);
>>       ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | 1);
>> @@ -166,11 +171,21 @@ static void sh_mobile_ceu_capture(struct
>>
>>       ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);
>>
>> -     if (pcdev->active) {
>> -             pcdev->active->state = VIDEOBUF_ACTIVE;
>> -             ceu_write(pcdev, CDAYR, videobuf_to_dma_contig(pcdev->active));
>> -             ceu_write(pcdev, CAPSR, 0x1); /* start capture */
>> +     if (!pcdev->active)
>> +             return;
>> +
>> +     phys_addr = videobuf_to_dma_contig(pcdev->active);
>> +     ceu_write(pcdev, CDAYR, phys_addr);
>
> Hm, looks like someone could have reviewed this driver a bit better on
> submission:-) I think, your ceu_write() should really take a u32 as an
> argument, not unsigned long, respectively, ceu_read() should return u32.

Well, to fit nicely together with ioread32() and iowrite32() i suppose
u32 is a better fit. Otoh, both u32 and unsigned longs are 32-bit on
regular 32-bit SuperH unless I'm mistaken.

> So there is even less motivation for "unsigned long phys_addr" above. A
> patch to change these functions would be welcome:-)

Usually physically addresses are kept as unsigned longs in the kernel.
That's the reason behind the unsigned longs. The best would of course
be to use an unsigned long to keep a pfn, but I'd say having an
unsigned long to keep the physical address as-is is close enough since
the hardware is using 32-bit registers for destination addresses
anyway. dma_addr_t sounds like a good plan though.

I agree about the parenthesis issues - I'll suspect I used them
because of compiler warnings, but I'll have a look.

I will post a cleanup patch that you can apply on top of this patch
and the interlace patch. This to avoid changing the interlace patch.

Thanks for your help!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
