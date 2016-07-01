Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41401 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbcGAL4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 07:56:08 -0400
Subject: Re: [patch V4 14/31] media: use parity functions in saa7115
To: zengzhaoxiu@163.com, linux-kernel@vger.kernel.org
References: <1462955158-28394-1-git-send-email-zengzhaoxiu@163.com>
 <1462958344-25186-1-git-send-email-zengzhaoxiu@163.com>
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9a626ceb-4ee2-56a2-9046-9bc9bce4e1e8@xs4all.nl>
Date: Fri, 1 Jul 2016 13:53:21 +0200
MIME-Version: 1.0
In-Reply-To: <1462958344-25186-1-git-send-email-zengzhaoxiu@163.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2016 11:19 AM, zengzhaoxiu@163.com wrote:
> From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
> 
> Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> ---
>  drivers/media/i2c/saa7115.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> index d2a1ce2..4c22df8 100644
> --- a/drivers/media/i2c/saa7115.c
> +++ b/drivers/media/i2c/saa7115.c
> @@ -672,15 +672,6 @@ static const unsigned char saa7115_init_misc[] = {
>  	0x00, 0x00
>  };
>  
> -static int saa711x_odd_parity(u8 c)
> -{
> -	c ^= (c >> 4);
> -	c ^= (c >> 2);
> -	c ^= (c >> 1);
> -
> -	return c & 1;
> -}
> -
>  static int saa711x_decode_vps(u8 *dst, u8 *p)
>  {
>  	static const u8 biphase_tbl[] = {
> @@ -733,7 +724,6 @@ static int saa711x_decode_wss(u8 *p)
>  	static const int wss_bits[8] = {
>  		0, 0, 0, 1, 0, 1, 1, 1
>  	};
> -	unsigned char parity;
>  	int wss = 0;
>  	int i;
>  
> @@ -745,11 +735,8 @@ static int saa711x_decode_wss(u8 *p)
>  			return -1;
>  		wss |= b2 << i;
>  	}
> -	parity = wss & 15;
> -	parity ^= parity >> 2;
> -	parity ^= parity >> 1;
>  
> -	if (!(parity & 1))
> +	if (!parity4(wss))
>  		return -1;
>  
>  	return wss;
> @@ -1235,7 +1222,7 @@ static int saa711x_decode_vbi_line(struct v4l2_subdev *sd, struct v4l2_decode_vb
>  		vbi->type = V4L2_SLICED_TELETEXT_B;
>  		break;
>  	case 4:
> -		if (!saa711x_odd_parity(p[0]) || !saa711x_odd_parity(p[1]))
> +		if (!parity8(p[0]) || !parity8(p[1]))
>  			return 0;
>  		vbi->type = V4L2_SLICED_CAPTION_525;
>  		break;
> 
