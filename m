Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52073 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab2KIOTb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Nov 2012 09:19:31 -0500
Message-ID: <509D10D6.3030707@iki.fi>
Date: Fri, 09 Nov 2012 16:19:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] it913x: [BUG] fix correct endpoint size when pid filter
 on.
References: <509AF219.6030907@iki.fi> <1352396904.3036.0.camel@Route3278>  <509C138F.1000402@iki.fi> <1352410221.17913.23.camel@Route3278>
In-Reply-To: <1352410221.17913.23.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/08/2012 11:30 PM, Malcolm Priestley wrote:
> On Thu, 2012-11-08 at 22:18 +0200, Antti Palosaari wrote:
>> On 11/08/2012 07:48 PM, Malcolm Priestley wrote:
>>>
>>> On 07/11/12 23:43, Antti Palosaari wrote:
>>>> Malcolm,
>>>> Have you newer tested it with USB1.1 port? Stream is totally broken.
>>>>
>>> Hi Antti
>>>
>>> Hmm, yes it is a bit choppy on dvb-usb-v2.
>>>
>>> I will have a look at it.
>>
>> Fedora's stock 3.6.5-1.fc17.x86_64 is even more worse - no picture at
>> all when using vlc. Clearly visible difference is pid filter count.
>> dvb-usb says 5 filters whilst dvb-usb-v2 says 32 pid filters.
>>
>> dvb_usb_v2: will use the device's hardware PID filter (table count: 32)
>> dvb-usb: will use the device's hardware PID filter (table count: 5).
>>
>>
> I kept the count as the hardware default with dvb-usb-v2, with 5, users
> can still run in to trouble with Video PIDs.
>
> I have traced it to an incorrect endpoint size when the PID filter
> is enabled. It also affected USB 2.0 with the filter on.


Bug fixed. Lets add proper tags. Happy weekend!

Reported-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>

>
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>   drivers/media/usb/dvb-usb-v2/it913x.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
> index 695f910..29300e3 100644
> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
> @@ -643,7 +643,8 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
>   	struct it913x_state *st = d->priv;
>   	int ret = 0;
>   	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
> -	u16 ep_size = adap->stream.buf_size / 4;
> +	u16 ep_size = (adap->pid_filtering) ? TS_BUFFER_SIZE_PID / 4 :
> +		TS_BUFFER_SIZE_MAX / 4;
>   	u8 pkt_size = 0x80;
>
>   	if (d->udev->speed != USB_SPEED_HIGH)
>


-- 
http://palosaari.fi/
