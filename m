Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:61222 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0ART7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 14:59:39 -0500
Message-ID: <4B54BDA3.2020403@freemail.hu>
Date: Mon, 18 Jan 2010 20:59:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2, RFC] gspca: add input support for interrupt endpoints
References: <4B530BBA.7080400@freemail.hu> <4B53D671.80206@redhat.com>
In-Reply-To: <4B53D671.80206@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> Thanks for your continued work on this. I'm afraid I found
> one thing which needs fixing (can be fixed with
> a separate patch after merging, but that is up to
> Jean-Francois).
> 
> See my comments inline.

Thanks for the feedback, I hope the quality of the software increases
during this review phase.

> On 01/17/2010 02:08 PM, Németh Márton wrote:
[snip]
>> +#ifdef CONFIG_INPUT
>> +#if LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 19)
>> +static void int_irq(struct urb *urb, struct pt_regs *regs)
>> +#else
>> +static void int_irq(struct urb *urb)
>> +#endif
>> +{
>> +	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
>> +	int ret;
>> +
>> +	if (urb->status == 0) {
>> +		if (gspca_dev->sd_desc->int_pkt_scan(gspca_dev,
>> +		    urb->transfer_buffer, urb->actual_length)<  0) {
>> +			PDEBUG(D_ERR, "Unknown packet received");
>> +		}
>> +
>> +		ret = usb_submit_urb(urb, GFP_ATOMIC);
>> +		if (ret<  0)
>> +			PDEBUG(D_ERR, "Resubmit URB failed with error %i", ret);
>> +	}
>> +}
>> +
> 
> If the status is not 0 you should print an error message, and
> reset the status and still resubmit the urb, if you don't resubmit
> on error, after one single usb glitch, the button will stop working.

I rewrote this function, see the following patch version.

[snip]
>> @@ -2137,6 +2308,11 @@
>>
>>   	usb_set_intfdata(intf, gspca_dev);
>>   	PDEBUG(D_PROBE, "%s created", video_device_node_name(&gspca_dev->vdev));
>> +
>> +	ret = gspca_input_connect(gspca_dev);
>> +	if (0<= ret)
>> +		ret = gspca_input_create_urb(gspca_dev);
>> +
> 
> I don't like this reverse psychology if. Why not just write:
> if (ret == 0) ?

I changed this line to "if (ret == 0)".

When I use a not-equal relation I try to put the smaller value on the left
hand side and the bigger one to the right hand side. In this case a range
which is expressed in mathematical notation like 10 < a <= 16 can be written
in C like (10 < a) && (a <= 16).

But it is a different question what people like and what not, so I've changed
that line.

> Otherwise it looks good.
Thanks.

I'm looking forward to receive more comments on the new version of this patch.

Regars,

	Márton Németh
