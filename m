Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:36583 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752081AbdFLMuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 08:50:21 -0400
Received: by mail-qt0-f176.google.com with SMTP id u19so123959087qta.3
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 05:50:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170607144616.15247-5-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl> <20170607144616.15247-5-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 12 Jun 2017 14:50:20 +0200
Message-ID: <CA+M3ks4Y0Dz+_qecCx7cAGkPfTE4pwfrG0BCkeNjGYj=Nz=_KQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] stih-cec/vivid/pulse8/rainshadow: use cec_transmit_attempt_done
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-06-07 16:46 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Use the helper function cec_transmit_attempt_done instead of
> cec_transmit_done to simplify the code.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/media/platform/sti/cec/stih-cec.c         | 9 ++++-----
>  drivers/media/platform/vivid/vivid-cec.c          | 6 +++---
>  drivers/media/usb/pulse8-cec/pulse8-cec.c         | 9 +++------
>  drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 9 +++------
>  4 files changed, 13 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
> index 6f9f03670b56..dccbdaebb7a8 100644
> --- a/drivers/media/platform/sti/cec/stih-cec.c
> +++ b/drivers/media/platform/sti/cec/stih-cec.c
> @@ -226,22 +226,21 @@ static int stih_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>  static void stih_tx_done(struct stih_cec *cec, u32 status)
>  {
>         if (status & CEC_TX_ERROR) {
> -               cec_transmit_done(cec->adap, CEC_TX_STATUS_ERROR, 0, 0, 0, 1);
> +               cec_transmit_attempt_done(cec->adap, CEC_TX_STATUS_ERROR);
>                 return;
>         }
>
>         if (status & CEC_TX_ARB_ERROR) {
> -               cec_transmit_done(cec->adap,
> -                                 CEC_TX_STATUS_ARB_LOST, 1, 0, 0, 0);
> +               cec_transmit_attempt_done(cec->adap, CEC_TX_STATUS_ARB_LOST);
>                 return;
>         }
>
>         if (!(status & CEC_TX_ACK_GET_STS)) {
> -               cec_transmit_done(cec->adap, CEC_TX_STATUS_NACK, 0, 1, 0, 0);
> +               cec_transmit_attempt_done(cec->adap, CEC_TX_STATUS_NACK);
>                 return;
>         }
>
> -       cec_transmit_done(cec->adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
> +       cec_transmit_attempt_done(cec->adap, CEC_TX_STATUS_OK);
>  }
>
>  static void stih_rx_done(struct stih_cec *cec, u32 status)
> diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
> index 653f4099f737..e15705758969 100644
> --- a/drivers/media/platform/vivid/vivid-cec.c
> +++ b/drivers/media/platform/vivid/vivid-cec.c
> @@ -34,7 +34,7 @@ void vivid_cec_bus_free_work(struct vivid_dev *dev)
>                 cancel_delayed_work_sync(&cw->work);
>                 spin_lock(&dev->cec_slock);
>                 list_del(&cw->list);
> -               cec_transmit_done(cw->adap, CEC_TX_STATUS_LOW_DRIVE, 0, 0, 1, 0);
> +               cec_transmit_attempt_done(cw->adap, CEC_TX_STATUS_LOW_DRIVE);
>                 kfree(cw);
>         }
>         spin_unlock(&dev->cec_slock);
> @@ -84,7 +84,7 @@ static void vivid_cec_xfer_done_worker(struct work_struct *work)
>         dev->cec_xfer_start_jiffies = 0;
>         list_del(&cw->list);
>         spin_unlock(&dev->cec_slock);
> -       cec_transmit_done(cw->adap, cw->tx_status, 0, valid_dest ? 0 : 1, 0, 0);
> +       cec_transmit_attempt_done(cw->adap, cw->tx_status);
>
>         /* Broadcast message */
>         if (adap != dev->cec_rx_adap)
> @@ -105,7 +105,7 @@ static void vivid_cec_xfer_try_worker(struct work_struct *work)
>         if (dev->cec_xfer_time_jiffies) {
>                 list_del(&cw->list);
>                 spin_unlock(&dev->cec_slock);
> -               cec_transmit_done(cw->adap, CEC_TX_STATUS_ARB_LOST, 1, 0, 0, 0);
> +               cec_transmit_attempt_done(cw->adap, CEC_TX_STATUS_ARB_LOST);
>                 kfree(cw);
>         } else {
>                 INIT_DELAYED_WORK(&cw->work, vivid_cec_xfer_done_worker);
> diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
> index 1dfc2de1fe77..c843070f24c1 100644
> --- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
> +++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
> @@ -148,18 +148,15 @@ static void pulse8_irq_work_handler(struct work_struct *work)
>                 cec_received_msg(pulse8->adap, &pulse8->rx_msg);
>                 break;
>         case MSGCODE_TRANSMIT_SUCCEEDED:
> -               cec_transmit_done(pulse8->adap, CEC_TX_STATUS_OK,
> -                                 0, 0, 0, 0);
> +               cec_transmit_attempt_done(pulse8->adap, CEC_TX_STATUS_OK);
>                 break;
>         case MSGCODE_TRANSMIT_FAILED_ACK:
> -               cec_transmit_done(pulse8->adap, CEC_TX_STATUS_NACK,
> -                                 0, 1, 0, 0);
> +               cec_transmit_attempt_done(pulse8->adap, CEC_TX_STATUS_NACK);
>                 break;
>         case MSGCODE_TRANSMIT_FAILED_LINE:
>         case MSGCODE_TRANSMIT_FAILED_TIMEOUT_DATA:
>         case MSGCODE_TRANSMIT_FAILED_TIMEOUT_LINE:
> -               cec_transmit_done(pulse8->adap, CEC_TX_STATUS_ERROR,
> -                                 0, 0, 0, 1);
> +               cec_transmit_attempt_done(pulse8->adap, CEC_TX_STATUS_ERROR);
>                 break;
>         }
>  }
> diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> index ad468efc4399..f203699e9c1b 100644
> --- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> +++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> @@ -98,16 +98,13 @@ static void rain_process_msg(struct rain *rain)
>
>         switch (stat) {
>         case 1:
> -               cec_transmit_done(rain->adap, CEC_TX_STATUS_OK,
> -                                 0, 0, 0, 0);
> +               cec_transmit_attempt_done(rain->adap, CEC_TX_STATUS_OK);
>                 break;
>         case 2:
> -               cec_transmit_done(rain->adap, CEC_TX_STATUS_NACK,
> -                                 0, 1, 0, 0);
> +               cec_transmit_attempt_done(rain->adap, CEC_TX_STATUS_NACK);
>                 break;
>         default:
> -               cec_transmit_done(rain->adap, CEC_TX_STATUS_LOW_DRIVE,
> -                                 0, 0, 0, 1);
> +               cec_transmit_attempt_done(rain->adap, CEC_TX_STATUS_LOW_DRIVE);
>                 break;
>         }
>  }
> --
> 2.11.0
>

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
