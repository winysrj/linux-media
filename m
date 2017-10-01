Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward2j.cmail.yandex.net ([5.255.227.20]:60792 "EHLO
        forward2j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750902AbdJAGGK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 02:06:10 -0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <6e7255bf2c5c1908716cfdf2b894a6f4682fe964.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com><cover.1506448061.git.mchehab@s-opensource.com> <6e7255bf2c5c1908716cfdf2b894a6f4682fe964.1506448061.git.mchehab@s-opensource.com>
Subject: Re: [PATCH 10/10] [RFC] w1_netlink.h: add support for nested structs
MIME-Version: 1.0
Message-Id: <154021506837475@web6g.yandex.ru>
Date: Sun, 01 Oct 2017 08:57:55 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

26.09.2017, 20:59, "Mauro Carvalho Chehab" <mchehab@s-opensource.com>:
> Describe nested struct/union fields
>
> NOTE: This is a pure test patch, meant to validate if the
> parsing logic for nested structs is working properly.
>
> I've no idea if the random text I added there is correct!

It looks correct, although I would switch master bus with bus master.

Feel free to add my acked-by.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/w1/w1_netlink.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
> index a36661cd1f05..e781d1109cd7 100644
> --- a/drivers/w1/w1_netlink.h
> +++ b/drivers/w1/w1_netlink.h
> @@ -60,6 +60,10 @@ enum w1_netlink_message_types {
>   * @status: kernel feedback for success 0 or errno failure value
>   * @len: length of data following w1_netlink_msg
>   * @id: union holding master bus id (msg.id) and slave device id (id[8]).
> + * @id.id: Slave ID (8 bytes)
> + * @id.mst: master bus identification
> + * @id.mst.id: master bus ID
> + * @id.mst.res: master bus reserved
>   * @data: start address of any following data
>   *
>   * The base message structure for w1 messages over netlink.
> --
> 2.13.5
