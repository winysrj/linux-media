Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37680 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2BZOy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 09:54:56 -0500
Received: by vcqp1 with SMTP id p1so1020243vcq.19
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2012 06:54:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH9_wRNGERctBxYT5NNEHOhuzWZYF2yKxG4BA6pzPzBWPy8_3Q@mail.gmail.com>
References: <CAH9_wRN5=nHtB9M3dL4wvZGL3+mb4_TfS=uPun_13D7n0E3CKA@mail.gmail.com>
	<CAKnK67T=obVTWkzZqVtv+PninjkbLp1os5AnsoZ+j=NGFFMWLA@mail.gmail.com>
	<CAH9_wRNGERctBxYT5NNEHOhuzWZYF2yKxG4BA6pzPzBWPy8_3Q@mail.gmail.com>
Date: Sun, 26 Feb 2012 20:24:55 +0530
Message-ID: <CAH9_wRN9bA8JTViBA6sWk9aVOU1Pbr5bPFvNh2MCsGUVjnr9qg@mail.gmail.com>
Subject: Re: Video Capture Issue
From: Sriram V <vshrirama@gmail.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
  When I take the dump of the buffer which is pointed by "DATA MEM
PING ADDRESS". It always shows 0x55.
  Even if i write 0x00 to the address. I do notice that it quickly
changes to 0x55.
  Under what conditions could this happen? What am i missing here.

  I do notice that the OMAP4 ISS is tested to work with OV5640 (YUV422
Frames) and OV5650 (Raw Data)
  When you say 422 Frames only. Do you mean 422-8Bit Mode?.

  I havent tried RAW12 which my device gives, Do i have to update only
the Data Format Selection register
  of the ISS  for RAW12?

  Please advice.


On Thu, Feb 23, 2012 at 11:24 PM, Sriram V <vshrirama@gmail.com> wrote:
> Hi,
>  1) An Hexdump of the captured file shows 0x55 at all locations.
>      Is there any buffer location i need to check.
>  2) I have tried with  "devel" branch.
>  3) Changing the polarities doesnt help either.
>  4) The sensor is giving out YUV422 8Bit Mode,
>      Will 0x52001074 = 0x0A00001E (UYVY Format)  it bypass the ISP
>       and dump directly into memory.
>
> On 2/23/12, Aguirre, Sergio <saaguirre@ti.com> wrote:
>> Hi Sriram,
>>
>> On Thu, Feb 23, 2012 at 11:25 AM, Sriram V <vshrirama@gmail.com> wrote:
>>> Hi,
>>>  1) I am trying to get a HDMI to CSI Bridge chip working with OMAP4 ISS.
>>>      The issue is the captured frames are completely green in color.
>>
>> Sounds like the buffer is all zeroes, can you confirm?
>>
>>>  2) The Chip is configured to output VGA Color bar sequence with
>>> YUV422-8Bit and
>>>       uses datalane 0 only.
>>>  3) The Format on OMAP4 ISS  is UYVY (Register 0x52001074 = 0x0A00001E)
>>>  I am trying to directly dump the data into memory without ISP processing.
>>>
>>>
>>>  Please advice.
>>
>> Just to be clear on your environment, which branch/commitID are you based
>> on?
>>
>> Regards,
>> Sergio
>>
>>>
>>> --
>>> Regards,
>>> Sriram
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Regards,
> Sriram



-- 
Regards,
Sriram
