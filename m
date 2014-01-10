Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaAJPCu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 10:02:50 -0500
Message-ID: <52D00B51.7090009@redhat.com>
Date: Fri, 10 Jan 2014 16:01:37 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>,
	Ethan Zhao <ethan.kernel@gmail.com>
CC: hans.verkuil@cisco.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: gspaca: check pointer against NULL before using
 it in create_urbs()
References: <1389088562-463-1-git-send-email-ethan.kernel@gmail.com> <52CFF094.5080408@cisco.com>
In-Reply-To: <52CFF094.5080408@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch, but the return value is already checked earlier on when
building the ep_tb table, so it can never return NULL here.

Regards,

Hans

On 01/10/2014 02:07 PM, Hans Verkuil wrote:
> Cc to linux-media and Hans de Goede (gspca maintainer).
>
> Regards,
>
> 	Hans
>
> On 01/07/14 10:56, Ethan Zhao wrote:
>> function alt_xfer() may return NULL, should check its return value passed into
>> create_urbs() as parameter.
>>
>> gspca_init_transfer()
>> {
>> ... ...
>> ret = create_urbs(gspca_dev,alt_xfer(&intf->altsetting[alt], xfer));
>> ... ...
>> }
>>
>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>> ---
>>   drivers/media/usb/gspca/gspca.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
>> index 048507b..eb45bc0 100644
>> --- a/drivers/media/usb/gspca/gspca.c
>> +++ b/drivers/media/usb/gspca/gspca.c
>> @@ -761,6 +761,8 @@ static int create_urbs(struct gspca_dev *gspca_dev,
>>   	struct urb *urb;
>>   	int n, nurbs, i, psize, npkt, bsize;
>>
>> +	if (!ep)
>> +		return -EINVAL;
>>   	/* calculate the packet size and the number of packets */
>>   	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
>>
>>
