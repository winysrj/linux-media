Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:40703 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbeBBHmJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 02:42:09 -0500
Received: by mail-ua0-f195.google.com with SMTP id t6so13615069ual.7
        for <linux-media@vger.kernel.org>; Thu, 01 Feb 2018 23:42:09 -0800 (PST)
Received: from mail-ua0-f182.google.com (mail-ua0-f182.google.com. [209.85.217.182])
        by smtp.gmail.com with ESMTPSA id y123sm405512vkd.9.2018.02.01.23.42.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Feb 2018 23:42:07 -0800 (PST)
Received: by mail-ua0-f182.google.com with SMTP id n2so13637117uak.9
        for <linux-media@vger.kernel.org>; Thu, 01 Feb 2018 23:42:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180202073316.ovee5fbe45npksnt@paasikivi.fi.intel.com>
References: <20171215075625.27028-1-acourbot@chromium.org> <20171215075625.27028-2-acourbot@chromium.org>
 <20180126083936.5qxacbdprm6j7pcc@valkosipuli.retiisi.org.uk>
 <CAPBb6MVAaGPh-sxD0ZTMbo2Ejtp8Rpqb8+OaKxhAC=BaT360eQ@mail.gmail.com> <20180202073316.ovee5fbe45npksnt@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 2 Feb 2018 16:41:45 +0900
Message-ID: <CAAFQd5BtOac2Mi9yTpma=96RQhtjTcBXYoSc2LkStYJx+s7jSA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/9] media: add request API core and UAPI
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 2, 2018 at 4:33 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>> >> +/**
>> >> + * struct media_request_queue - queue of requests
>> >> + *
>> >> + * @mdev:    media_device that manages this queue
>> >> + * @ops:     implementation of the queue
>> >> + * @mutex:   protects requests, active_request, req_id, and all members of
>> >> + *           struct media_request
>> >> + * @active_request: request being currently run by this queue
>> >> + * @requests:        list of requests (not in any particular order) that this
>> >> + *           queue owns.
>> >> + * @req_id:  counter used to identify requests for debugging purposes
>> >> + */
>> >> +struct media_request_queue {
>> >> +     struct media_device *mdev;
>> >> +     const struct media_request_queue_ops *ops;
>> >> +
>> >> +     struct mutex mutex;
>> >
>> > Any particular reason for using a mutex? The request queue lock will need
>> > to be acquired from interrupts, too, so this should be changed to a
>> > spinlock.
>>
>> Will it be acquired from interrupts? In any case it should be possible
>> to change this to a spinlock.
>
> Using mutexes will effectively make this impossible, and I don't think we
> can safely say there's not going to be a need for that. So spinlocks,
> please.
>

IMHO whether a mutex or spinlock is the right thing depends on what
kind of critical section it is used for. If it only protects data (and
according to the comment, this one seems to do so), spinlock might
actually have better properties, e.g. not introducing the need to
reschedule, if another CPU is accessing the data at the moment. It
might also depend on how heavy the data accesses are, though. We
shouldn't need to spin for too long time.

Best regards,
Tomasz
