Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2E2JPD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 05:15:03 -0400
Message-ID: <4FC4939D.80601@redhat.com>
Date: Tue, 29 May 2012 11:15:09 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca - ov534/ov534_9: Fix sccd_read/write errors
References: <20120528190407.463f7d6e@tele>
In-Reply-To: <20120528190407.463f7d6e@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks I've added this and the sonixj fixes to my tree and send an
updated pullreq to Mauro to include these in the next round of
fixes for 3.5

Regards,

Hans


On 05/28/2012 07:04 PM, Jean-Francois Moine wrote:
> The ov534 bridge is too slow to handle the sensor accesses
> requested by fast hosts giving 'sccb_reg_write failed'.
> A small delay fixes the problem.
>
> Signed-off-by: Jean-François Moine<moinejf@free.fr>
> ---
>   drivers/media/video/gspca/ov534.c   |    1 +
>   drivers/media/video/gspca/ov534_9.c |    1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
> index b5acb1e..d5a7873 100644
> --- a/drivers/media/video/gspca/ov534.c
> +++ b/drivers/media/video/gspca/ov534.c
> @@ -851,6 +851,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
>   	int i;
>
>   	for (i = 0; i<  5; i++) {
> +		msleep(10);
>   		data = ov534_reg_read(gspca_dev, OV534_REG_STATUS);
>
>   		switch (data) {
> diff --git a/drivers/media/video/gspca/ov534_9.c b/drivers/media/video/gspca/ov534_9.c
> index e6601b8..0120f94 100644
> --- a/drivers/media/video/gspca/ov534_9.c
> +++ b/drivers/media/video/gspca/ov534_9.c
> @@ -1008,6 +1008,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
>   	int i;
>
>   	for (i = 0; i<  5; i++) {
> +		msleep(10);
>   		data = reg_r(gspca_dev, OV534_REG_STATUS);
>
>   		switch (data) {
