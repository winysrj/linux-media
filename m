Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44449 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2BWRy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 12:54:58 -0500
Received: by vbjk17 with SMTP id k17so987537vbj.19
        for <linux-media@vger.kernel.org>; Thu, 23 Feb 2012 09:54:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKnK67T=obVTWkzZqVtv+PninjkbLp1os5AnsoZ+j=NGFFMWLA@mail.gmail.com>
References: <CAH9_wRN5=nHtB9M3dL4wvZGL3+mb4_TfS=uPun_13D7n0E3CKA@mail.gmail.com>
	<CAKnK67T=obVTWkzZqVtv+PninjkbLp1os5AnsoZ+j=NGFFMWLA@mail.gmail.com>
Date: Thu, 23 Feb 2012 23:24:57 +0530
Message-ID: <CAH9_wRNGERctBxYT5NNEHOhuzWZYF2yKxG4BA6pzPzBWPy8_3Q@mail.gmail.com>
Subject: Re: Video Capture Issue
From: Sriram V <vshrirama@gmail.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
  1) An Hexdump of the captured file shows 0x55 at all locations.
      Is there any buffer location i need to check.
  2) I have tried with  "devel" branch.
  3) Changing the polarities doesnt help either.
  4) The sensor is giving out YUV422 8Bit Mode,
      Will 0x52001074 = 0x0A00001E (UYVY Format)  it bypass the ISP
       and dump directly into memory.

On 2/23/12, Aguirre, Sergio <saaguirre@ti.com> wrote:
> Hi Sriram,
>
> On Thu, Feb 23, 2012 at 11:25 AM, Sriram V <vshrirama@gmail.com> wrote:
>> Hi,
>>  1) I am trying to get a HDMI to CSI Bridge chip working with OMAP4 ISS.
>>      The issue is the captured frames are completely green in color.
>
> Sounds like the buffer is all zeroes, can you confirm?
>
>>  2) The Chip is configured to output VGA Color bar sequence with
>> YUV422-8Bit and
>>       uses datalane 0 only.
>>  3) The Format on OMAP4 ISS  is UYVY (Register 0x52001074 = 0x0A00001E)
>>  I am trying to directly dump the data into memory without ISP processing.
>>
>>
>>  Please advice.
>
> Just to be clear on your environment, which branch/commitID are you based
> on?
>
> Regards,
> Sergio
>
>>
>> --
>> Regards,
>> Sriram
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Regards,
Sriram
