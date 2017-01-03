Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36520 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757622AbdACKtd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 05:49:33 -0500
Received: by mail-yw0-f179.google.com with SMTP id a10so285300238ywa.3
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2017 02:49:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <443aa078-e93d-6374-a6c6-811c862fb679@soulik.info>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
 <1483347004-32593-3-git-send-email-ayaka@soulik.info> <20170102091013.GG3958@valkosipuli.retiisi.org.uk>
 <70da89ca-c184-aee5-e133-c13b3bbf6be9@soulik.info> <20170102110715.GH3958@valkosipuli.retiisi.org.uk>
 <443aa078-e93d-6374-a6c6-811c862fb679@soulik.info>
From: Daniel Stone <daniel@fooishbar.org>
Date: Tue, 3 Jan 2017 10:49:32 +0000
Message-ID: <CAPj87rPKo1OHnRK=fhU9Se3itbrySr=fQOOtgyYth2ciQ__CGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] v4l: Add 10-bits per channel YUV pixel formats
To: ayaka <ayaka@soulik.info>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        randy.li@rock-chips.com, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 2 January 2017 at 13:03, ayaka <ayaka@soulik.info> wrote:
> On 01/02/2017 07:07 PM, Sakari Ailus wrote:
>> On Mon, Jan 02, 2017 at 06:53:16PM +0800, ayaka wrote:
>>> On 01/02/2017 05:10 PM, Sakari Ailus wrote:
>>>> If the format resembles the existing formats but on a different bit
>>>> depth,
>>>> it should be named in similar fashion.
>>>
>>> Do you mean it would be better if it is called as NV12_10?
>>
>> If it otherwise resembles NV12 but just has 10 bits per pixel, I think
>> NV12_10 is a good name for it.
>
> The main reason I don't like it is that there is a various of software
> having used the P010 for this kind of pixel format. It would leadi a
> conflict between them(and I never saw it is used as NV12_10), as the P010 is
> more common to be used.

Indeed; GStreamer, FFmpeg and Microsoft all call this P010:
https://msdn.microsoft.com/en-us/library/windows/desktop/bb970578(v=vs.85).aspx

fourcc.org is supposed to reflect Microsoft's registry, but seems to
not be actively maintained anymore.

Cheers,
Daniel
