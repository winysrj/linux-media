Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:35032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZFQI0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 04:26:14 -0400
Received: by fg-out-1718.google.com with SMTP id d23so808182fga.17
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 01:26:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090616134422.3006c142@pedra.chehab.org>
References: <886732.24607.qm@web110811.mail.gq1.yahoo.com>
	 <37219a840905190923k60e9daecve4d9a1de176bdbd8@mail.gmail.com>
	 <3E442BA883529143B4AB72530285FC5D01E212C0@s-mail.siano-ms.ent>
	 <20090616134422.3006c142@pedra.chehab.org>
Date: Wed, 17 Jun 2009 11:26:15 +0300
Message-ID: <f1e62fb30906170126q7b69436ey1e1b0cd7b2525f4e@mail.gmail.com>
Subject: Re: [PATCH] [09051_49] Siano: smscore - upgrade firmware loading
	engine
From: Udi Atar <udi.linuxtv@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 16, 2009 at 7:44 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Tue, 16 Jun 2009 15:39:01 +0300
> "Udi Atar" <udia@siano-ms.com> escreveu:
>
>> The README.patches file in v4l-dvb clearly states that it is OK to use version checking to allow backporting.
>>
>> ########################################################################
>> k) Sometimes it is necessary to introduce some testing code inside a
>>    module or remove parts that are not yet finished. Also, compatibility
>>    tests may be required to provide backporting.
>>
>>    To allow compatibility tests, linux/version.h is automatically
>>    included by the building system. This allows adding tests like:
>>
>>       #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 16)
>>       #include <linux/mutex.h>
>>       #else
>>       #include <asm/semaphore.h>
>>       #endif
>> ########################################################################
>>
>> The patch allows older version of the kernel, and embedded platforms, that choose not to include the "request firmware" mechanism to continue working with the Siano driver.
>
> I don't see a big issue with this, provided that this won't affect the upstream driver.
>
>> As for the SMS_HOSTLIB_SUBSYS, the Siano driver supports standards which are not currently implemented in V4L (i.e. CMMB). I see no reason why we should create a duplicate driver for DVB-T and CMMB, if the codebase is exactly the same.
>
> The proper way is to add support for those standards at DVB API, instead of
> using a proprietary API.
>
> In order to keep the merging process of the pending patches, I suggest you to
> remove the the SMS_HOSTLIB_SUBSYS part from this patch and re-submit the
> pending ones up to the point where the only pending issue to sync your codebase
> with kernel being the API for those non-supported standards. After that, we can
> discuss the API improvement needs to support the missing standards.
>>
>> Best regards,
>> Udi Atar
>>
>>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Michael Krufky
>> Sent: Tuesday, May 19, 2009 7:24 PM
>> To: Uri Shkolnik
>> Cc: LinuxML; Mauro Carvalho Chehab
>> Subject: Re: [PATCH] [09051_49] Siano: smscore - upgrade firmware loading engine
>>
>> On Tue, May 19, 2009 at 11:43 AM, Uri Shkolnik <urishk@yahoo.com> wrote:
>> >
>> > # HG changeset patch
>> > # User Uri Shkolnik <uris@siano-ms.com>
>> > # Date 1242748115 -10800
>> > # Node ID 4d75f9d1c4f96d65a8ad312c21e488a212ee58a3
>> > # Parent  cfb4106f3ceaee9fe8f7e3acc9d4adec1baffe5e
>> > [09051_49] Siano: smscore - upgrade firmware loading engine
>> >
>> > From: Uri Shkolnik <uris@siano-ms.com>
>> >
>> > Upgrade the firmware loading (download and switching) engine.
>> >
>> > Priority: normal
>> >
>> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
>> >
>> > diff -r cfb4106f3cea -r 4d75f9d1c4f9 linux/drivers/media/dvb/siano/smscoreapi.c
>> > --- a/linux/drivers/media/dvb/siano/smscoreapi.c        Tue May 19 18:38:07 2009 +0300
>> > +++ b/linux/drivers/media/dvb/siano/smscoreapi.c        Tue May 19 18:48:35 2009 +0300
>> > @@ -28,7 +28,7 @@
>> >  #include <linux/dma-mapping.h>
>> >  #include <linux/delay.h>
>> >  #include <linux/io.h>
>> > -
>> > +#include <linux/uaccess.h>
>> >  #include <linux/firmware.h>
>> >  #include <linux/wait.h>
>> >  #include <asm/byteorder.h>
>> > @@ -36,7 +36,13 @@
>> >  #include "smscoreapi.h"
>> >  #include "sms-cards.h"
>> >  #include "smsir.h"
>> > -#include "smsendian.h"
>> > +#define MAX_GPIO_PIN_NUMBER    31
>> > +
>> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 10)
>> > +#define REQUEST_FIRMWARE_SUPPORTED
>> > +#else
>> > +#define DEFAULT_FW_FILE_PATH "/lib/firmware"
>> > +#endif
>> >
>> >  static int sms_dbg;
>> >  module_param_named(debug, sms_dbg, int, 0644);
>> > @@ -459,8 +465,6 @@ static int smscore_init_ir(struct smscor
>> >                                msg->msgData[0] = coredev->ir.controller;
>> >                                msg->msgData[1] = coredev->ir.timeout;
>> >
>> > -                               smsendian_handle_tx_message(
>> > -                                       (struct SmsMsgHdr_ST2 *)msg);
>> >                                rc = smscore_sendrequest_and_wait(coredev, msg,
>> >                                                msg->xMsgHeader. msgLength,
>> >                                                &coredev->ir_init_done);
>> > @@ -486,12 +490,16 @@ static int smscore_init_ir(struct smscor
>> >  */
>> >  int smscore_start_device(struct smscore_device_t *coredev)
>> >  {
>> > -       int rc = smscore_set_device_mode(
>> > -                       coredev, smscore_registry_getmode(coredev->devpath));
>> > +       int rc;
>> > +
>> > +#ifdef REQUEST_FIRMWARE_SUPPORTED
>> > +       rc = smscore_set_device_mode(coredev, smscore_registry_getmode(
>> > +                       coredev->devpath));
>> >        if (rc < 0) {
>> > -               sms_info("set device mode faile , rc %d", rc);
>> > +               sms_info("set device mode failed , rc %d", rc);
>> >                return rc;
>> >        }
>> > +#endif
>> >
>> >        kmutex_lock(&g_smscore_deviceslock);
>> >
>> > @@ -632,11 +640,14 @@ static int smscore_load_firmware_from_fi
>> >                                           loadfirmware_t loadfirmware_handler)
>> >  {
>> >        int rc = -ENOENT;
>> > +       u8 *fw_buf;
>> > +       u32 fw_buf_size;
>> > +
>> > +#ifdef REQUEST_FIRMWARE_SUPPORTED
>> >        const struct firmware *fw;
>> > -       u8 *fw_buffer;
>> >
>> > -       if (loadfirmware_handler == NULL && !(coredev->device_flags &
>> > -                                             SMS_DEVICE_FAMILY2))
>> > +       if (loadfirmware_handler == NULL && !(coredev->device_flags
>> > +                       & SMS_DEVICE_FAMILY2))
>> >                return -EINVAL;
>> >
>> >        rc = request_firmware(&fw, filename, coredev->device);
>> > @@ -645,26 +656,36 @@ static int smscore_load_firmware_from_fi
>> >                return rc;
>> >        }
>> >        sms_info("read FW %s, size=%zd", filename, fw->size);
>> > -       fw_buffer = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
>> > -                           GFP_KERNEL | GFP_DMA);
>> > -       if (fw_buffer) {
>> > -               memcpy(fw_buffer, fw->data, fw->size);
>> > +       fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
>> > +                               GFP_KERNEL | GFP_DMA);
>> > +       if (!fw_buf) {
>> > +               sms_info("failed to allocate firmware buffer");
>> > +               return -ENOMEM;
>> > +       }
>> > +       memcpy(fw_buf, fw->data, fw->size);
>> > +       fw_buf_size = fw->size;
>> > +#else
>> > +       if (!coredev->fw_buf) {
>> > +               sms_info("missing fw file buffer");
>> > +               return -EINVAL;
>> > +       }
>> > +       fw_buf = coredev->fw_buf;
>> > +       fw_buf_size = coredev->fw_buf_size;
>> > +#endif
>> >
>> > -               rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
>> > -                     smscore_load_firmware_family2(coredev,
>> > -                                                   fw_buffer,
>> > -                                                   fw->size) :
>> > -                     loadfirmware_handler(coredev->context,
>> > -                                          fw_buffer, fw->size);
>> > +       rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
>> > +               smscore_load_firmware_family2(coredev, fw_buf, fw_buf_size)
>> > +               : loadfirmware_handler(coredev->context, fw_buf,
>> > +               fw_buf_size);
>> >
>> > -               kfree(fw_buffer);
>> > -       } else {
>> > -               sms_info("failed to allocate firmware buffer");
>> > -               rc = -ENOMEM;
>> > -       }
>> > +       kfree(fw_buf);
>> >
>> > +#ifdef REQUEST_FIRMWARE_SUPPORTED
>> >        release_firmware(fw);
>> > -
>> > +#else
>> > +       coredev->fw_buf = NULL;
>> > +       coredev->fw_buf_size = 0;
>> > +#endif
>> >        return rc;
>> >  }
>> >
>> > @@ -911,6 +932,74 @@ int smscore_set_device_mode(struct smsco
>> >  }
>> >
>> >  /**
>> > + * calls device handler to get fw file name
>> > + *
>> > + * @param coredev pointer to a coredev object returned by
>> > + *                smscore_register_device
>> > + * @param filename pointer to user buffer to fill the file name
>> > + *
>> > + * @return 0 on success, <0 on error.
>> > + */
>> > +int smscore_get_fw_filename(struct smscore_device_t *coredev, int mode,
>> > +               char *filename) {
>> > +       int rc = 0;
>> > +       enum sms_device_type_st type;
>> > +       char tmpname[200];
>> > +
>> > +       type = smscore_registry_gettype(coredev->devpath);
>> > +
>> > +#ifdef REQUEST_FIRMWARE_SUPPORTED
>> > +       /* driver not need file system services */
>> > +       tmpname[0] = '\0';
>> > +#else
>> > +       sprintf(tmpname, "%s/%s", DEFAULT_FW_FILE_PATH,
>> > +                       smscore_fw_lkup[mode][type]);
>> > +#endif
>> > +       if (copy_to_user(filename, tmpname, strlen(tmpname) + 1)) {
>> > +               sms_err("Failed copy file path to user buffer\n");
>> > +               return -EFAULT;
>> > +       }
>> > +       return rc;
>> > +}
>> > +
>> > +/**
>> > + * calls device handler to keep fw buff for later use
>> > + *
>> > + * @param coredev pointer to a coredev object returned by
>> > + *                smscore_register_device
>> > + * @param ufwbuf  pointer to user fw buffer
>> > + * @param size    size in bytes of buffer
>> > + *
>> > + * @return 0 on success, <0 on error.
>> > + */
>> > +int smscore_send_fw_file(struct smscore_device_t *coredev, u8 *ufwbuf,
>> > +               int size) {
>> > +       int rc = 0;
>> > +
>> > +       /* free old buffer */
>> > +       if (coredev->fw_buf != NULL) {
>> > +               kfree(coredev->fw_buf);
>> > +               coredev->fw_buf = NULL;
>> > +       }
>> > +
>> > +       coredev->fw_buf = kmalloc(ALIGN(size, SMS_ALLOC_ALIGNMENT), GFP_KERNEL
>> > +                       | GFP_DMA);
>> > +       if (!coredev->fw_buf) {
>> > +               sms_err("Failed allocate FW buffer memory\n");
>> > +               return -EFAULT;
>> > +       }
>> > +
>> > +       if (copy_from_user(coredev->fw_buf, ufwbuf, size)) {
>> > +               sms_err("Failed copy FW from user buffer\n");
>> > +               kfree(coredev->fw_buf);
>> > +               return -EFAULT;
>> > +       }
>> > +       coredev->fw_buf_size = size;
>> > +
>> > +       return rc;
>> > +}
>> > +
>> > +/**
>> >  * calls device handler to get current mode of operation
>> >  *
>> >  * @param coredev pointer to a coredev object returned by
>> > @@ -1280,7 +1369,7 @@ int smsclient_sendrequest(struct smscore
>> >  }
>> >  EXPORT_SYMBOL_GPL(smsclient_sendrequest);
>> >
>> > -#if 0
>> > +#ifdef SMS_HOSTLIB_SUBSYS
>> >  /**
>> >  * return the size of large (common) buffer
>> >  *
>> > @@ -1329,7 +1418,7 @@ static int smscore_map_common_buffer(str
>> >
>> >        return 0;
>> >  }
>> > -#endif
>> > +#endif /* SMS_HOSTLIB_SUBSYS */
>> >
>> >  /* old GPIO managments implementation */
>> >  int smscore_configure_gpio(struct smscore_device_t *coredev, u32 pin,
>> > @@ -1515,7 +1604,6 @@ int smscore_gpio_configure(struct smscor
>> >                pMsg->msgData[5] = 0;
>> >        }
>> >
>> > -       smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
>> >        rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
>> >                        &coredev->gpio_configuration_done);
>> >
>> > @@ -1565,7 +1653,6 @@ int smscore_gpio_set_level(struct smscor
>> >        pMsg->msgData[1] = NewLevel;
>> >
>> >        /* Send message to SMS */
>> > -       smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
>> >        rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
>> >                        &coredev->gpio_set_level_done);
>> >
>> > @@ -1614,7 +1701,6 @@ int smscore_gpio_get_level(struct smscor
>> >        pMsg->msgData[1] = 0;
>> >
>> >        /* Send message to SMS */
>> > -       smsendian_handle_tx_message((struct SmsMsgHdr_ST *)pMsg);
>> >        rc = smscore_sendrequest_and_wait(coredev, pMsg, totalLen,
>> >                        &coredev->gpio_get_level_done);
>> >
>> >
>> >
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>>
>>
>> This patch should not be merged in its current form.
>>
>> Linux kernel driver development shall be against the current -rc
>> kernel, and there is no need to reinvent the "REQUEST_FIRMWARE"
>> mechanism.
>>
>> Furthermore, the changeset introduces more bits of this
>> "SMS_HOSTLIB_SUBSYS" -- this requires a binary library present on the
>> host system.  This completely violates the "no multiple APIs in
>> kernel" and "no proprietary APIs in kernel" guidelines.
>>
>> Uri, what are your plans for this?
>>
>> Regards,
>>
>> Mike
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

OK.
Will resubmit the relevant patches.

Best regards,
Udi
