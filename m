Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35461 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdIAG2W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 02:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <cf4b97ba0e68bf92cf899d04a3862cad1b3a7874.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com> <cf4b97ba0e68bf92cf899d04a3862cad1b3a7874.1504222628.git.mchehab@s-opensource.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 1 Sep 2017 08:28:20 +0200
Message-ID: <CAJbz7-1PijPZm1Sa87cHQmwMDURtW4PVUZZT9OvHPTfeFQafHg@mail.gmail.com>
Subject: Re: [PATCH 12/15] media: dmx.h: get rid of DMX_SET_SOURCE
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-09-01 1:46 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> No driver uses this ioctl, nor it is documented anywhere.
>
> So, get rid of it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  Documentation/media/dmx.h.rst.exceptions        | 13 --------
>  Documentation/media/uapi/dvb/dmx-set-source.rst | 44 -------------------------
>  Documentation/media/uapi/dvb/dmx_fcalls.rst     |  1 -
>  Documentation/media/uapi/dvb/dmx_types.rst      | 20 -----------
>  include/uapi/linux/dvb/dmx.h                    | 12 -------
>  5 files changed, 90 deletions(-)
>  delete mode 100644 Documentation/media/uapi/dvb/dmx-set-source.rst
>
> diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
> index 5572d2dc9d0e..d2dac35bb84b 100644
> --- a/Documentation/media/dmx.h.rst.exceptions
> +++ b/Documentation/media/dmx.h.rst.exceptions
> @@ -40,18 +40,6 @@ replace enum dmx_input :c:type:`dmx_input`
>  replace symbol DMX_IN_FRONTEND :c:type:`dmx_input`
>  replace symbol DMX_IN_DVR :c:type:`dmx_input`
>
> -# dmx_source_t symbols
> -replace enum dmx_source :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_FRONT0 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_FRONT1 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_FRONT2 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_FRONT3 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_DVR0 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_DVR1 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_DVR2 :c:type:`dmx_source`
> -replace symbol DMX_SOURCE_DVR3 :c:type:`dmx_source`
> -
> -
>  # Flags for struct dmx_sct_filter_params
>  replace define DMX_CHECK_CRC :c:type:`dmx_sct_filter_params`
>  replace define DMX_ONESHOT :c:type:`dmx_sct_filter_params`
> @@ -61,4 +49,3 @@ replace define DMX_IMMEDIATE_START :c:type:`dmx_sct_filter_params`
>  replace typedef dmx_filter_t :c:type:`dmx_filter`
>  replace typedef dmx_pes_type_t :c:type:`dmx_pes_type`
>  replace typedef dmx_input_t :c:type:`dmx_input`
> -replace typedef dmx_source_t :c:type:`dmx_source`
> diff --git a/Documentation/media/uapi/dvb/dmx-set-source.rst b/Documentation/media/uapi/dvb/dmx-set-source.rst
> deleted file mode 100644
> index ac7f77b25e06..000000000000
> --- a/Documentation/media/uapi/dvb/dmx-set-source.rst
> +++ /dev/null
> @@ -1,44 +0,0 @@
> -.. -*- coding: utf-8; mode: rst -*-
> -
> -.. _DMX_SET_SOURCE:
> -
> -==============
> -DMX_SET_SOURCE
> -==============
> -
> -Name
> -----
> -
> -DMX_SET_SOURCE
> -
> -
> -Synopsis
> ---------
> -
> -.. c:function:: int ioctl(fd, DMX_SET_SOURCE, struct dmx_source *src)
> -    :name: DMX_SET_SOURCE
> -
> -
> -Arguments
> ----------
> -
> -
> -``fd``
> -    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
> -
> -``src``
> -   Undocumented.
> -
> -
> -Description
> ------------
> -
> -.. note:: This ioctl is undocumented. Documentation is welcome.
> -
> -
> -Return Value
> -------------
> -
> -On success 0 is returned, on error -1 and the ``errno`` variable is set
> -appropriately. The generic error codes are described at the
> -:ref:`Generic Error Codes <gen-errors>` chapter.
> diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/media/uapi/dvb/dmx_fcalls.rst
> index 49e013d4540f..be98d60877f2 100644
> --- a/Documentation/media/uapi/dvb/dmx_fcalls.rst
> +++ b/Documentation/media/uapi/dvb/dmx_fcalls.rst
> @@ -21,6 +21,5 @@ Demux Function Calls
>      dmx-get-event
>      dmx-get-stc
>      dmx-get-pes-pids
> -    dmx-set-source
>      dmx-add-pid
>      dmx-remove-pid
> diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
> index 9e907b85cf16..a205c02ccdc1 100644
> --- a/Documentation/media/uapi/dvb/dmx_types.rst
> +++ b/Documentation/media/uapi/dvb/dmx_types.rst
> @@ -197,23 +197,3 @@ struct dmx_stc
>         unsigned int base;  /* output: divisor for stc to get 90 kHz clock */
>         __u64 stc;      /* output: stc in 'base'*90 kHz units */
>      };
> -
> -
> -
> -enum dmx_source
> -===============
> -
> -.. c:type:: dmx_source
> -
> -.. code-block:: c
> -
> -    typedef enum dmx_source {
> -       DMX_SOURCE_FRONT0 = 0,
> -       DMX_SOURCE_FRONT1,
> -       DMX_SOURCE_FRONT2,
> -       DMX_SOURCE_FRONT3,
> -       DMX_SOURCE_DVR0   = 16,
> -       DMX_SOURCE_DVR1,
> -       DMX_SOURCE_DVR2,
> -       DMX_SOURCE_DVR3
> -    } dmx_source_t;
> diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
> index c0ee44fbdb13..dd2b832c02ce 100644
> --- a/include/uapi/linux/dvb/dmx.h
> +++ b/include/uapi/linux/dvb/dmx.h
> @@ -117,17 +117,6 @@ struct dmx_pes_filter_params
>         __u32          flags;
>  };
>
> -typedef enum dmx_source {
> -       DMX_SOURCE_FRONT0 = 0,
> -       DMX_SOURCE_FRONT1,
> -       DMX_SOURCE_FRONT2,
> -       DMX_SOURCE_FRONT3,
> -       DMX_SOURCE_DVR0   = 16,
> -       DMX_SOURCE_DVR1,
> -       DMX_SOURCE_DVR2,
> -       DMX_SOURCE_DVR3
> -} dmx_source_t;
> -
>  struct dmx_stc {
>         unsigned int num;       /* input : which STC? 0..N */
>         unsigned int base;      /* output: divisor for stc to get 90 kHz clock */
> @@ -140,7 +129,6 @@ struct dmx_stc {
>  #define DMX_SET_PES_FILTER       _IOW('o', 44, struct dmx_pes_filter_params)
>  #define DMX_SET_BUFFER_SIZE      _IO('o', 45)
>  #define DMX_GET_PES_PIDS         _IOR('o', 47, __u16[5])
> -#define DMX_SET_SOURCE           _IOW('o', 49, dmx_source_t)
>  #define DMX_GET_STC              _IOWR('o', 50, struct dmx_stc)
>  #define DMX_ADD_PID              _IOW('o', 51, __u16)
>  #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
> --
> 2.13.5
>

Hi Mauro.

May be I missed something, but how it should be managed the demux
source without that?
Do we have some other way how to set the demux input?

Even in one-frontend configuration we should have to have option
to switch between DMX_SOURCE_FRONT0 & DMX_SOURCE_DVR0.

/Honza
