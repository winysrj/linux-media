Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54396 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462Ab3KEXS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 18:18:28 -0500
Message-ID: <1383697199.1862.2.camel@palomino.walls.org>
Subject: Re: [PATCH v3 04/29] [media] cx18: struct i2c_client is too big for
 stack
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 05 Nov 2013 19:19:59 -0500
In-Reply-To: <1383645702-30636-5-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
	 <1383645702-30636-5-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2013-11-05 at 08:01 -0200, Mauro Carvalho Chehab wrote:
> 	drivers/media/pci/cx18/cx18-driver.c: In function 'cx18_read_eeprom':
> 	drivers/media/pci/cx18/cx18-driver.c:357:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> That happens because the routine allocates 256 bytes for an eeprom buffer, plus
> the size of struct i2c_client, with is big.
> Change the logic to dynamically allocate/deallocate space for struct i2c_client,
> instead of  using the stack.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/pci/cx18/cx18-driver.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index ff7232023f56..87f5bcf29e90 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -324,23 +324,24 @@ static void cx18_eeprom_dump(struct cx18 *cx, unsigned char *eedata, int len)
>  /* Hauppauge card? get values from tveeprom */
>  void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
>  {
> -	struct i2c_client c;
> +	struct i2c_client *c;
>  	u8 eedata[256];
>  
> -	memset(&c, 0, sizeof(c));
> -	strlcpy(c.name, "cx18 tveeprom tmp", sizeof(c.name));
> -	c.adapter = &cx->i2c_adap[0];
> -	c.addr = 0xA0 >> 1;
> +	c = kzalloc(sizeof(*c), GFP_ATOMIC);

Hi Mauro,

GFP_ATOMIC seems overly strict, as this function is not in called in an
atomic context AFAIK.

Maybe use GFP_TEMPORARY or GFP_KERNEL.

Regards,
Andy

> +
> +	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
> +	c->adapter = &cx->i2c_adap[0];
> +	c->addr = 0xa0 >> 1;
>  
>  	memset(tv, 0, sizeof(*tv));
> -	if (tveeprom_read(&c, eedata, sizeof(eedata)))
> -		return;
> +	if (tveeprom_read(c, eedata, sizeof(eedata)))
> +		goto ret;
>  
>  	switch (cx->card->type) {
>  	case CX18_CARD_HVR_1600_ESMT:
>  	case CX18_CARD_HVR_1600_SAMSUNG:
>  	case CX18_CARD_HVR_1600_S5H1411:
> -		tveeprom_hauppauge_analog(&c, tv, eedata);
> +		tveeprom_hauppauge_analog(c, tv, eedata);
>  		break;
>  	case CX18_CARD_YUAN_MPC718:
>  	case CX18_CARD_GOTVIEW_PCI_DVD3:
> @@ -354,6 +355,9 @@ void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
>  		cx18_eeprom_dump(cx, eedata, sizeof(eedata));
>  		break;
>  	}
> +
> +ret:
> +	kfree(c);
>  }
>  
>  static void cx18_process_eeprom(struct cx18 *cx)


