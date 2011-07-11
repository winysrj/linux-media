Return-path: <mchehab@localhost>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46523 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1GKV2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 17:28:31 -0400
Received: by iyb12 with SMTP id 12so4073045iyb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 14:28:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107111258.50144.laurent.pinchart@ideasonboard.com>
References: <CAH9NwWc+zLqPyBcC99wbsbNkdjzMFfn2zuGm1VfmZctgpOGMew@mail.gmail.com>
 <201107111258.50144.laurent.pinchart@ideasonboard.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 11 Jul 2011 21:28:11 +0000
Message-ID: <CAH9NwWecm8MUDNJPCaaWbA-6cX66foJnH7-S5CF7_nq9yg5U9A@mail.gmail.com>
Subject: Re: [PATCH 2/3] Document 8-bit and 16-bit YCrCb media bus pixel codes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Laurent,

2011/7/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Christian,
>
> On Sunday 10 July 2011 20:14:21 Christian Gmeiner wrote:
>> Signed-off-by: Christian Gmeiner
>> ---
>> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> b/Documentation/DocBook/media/v4l/subdev-formats.xml
>> index 49c532e..18e30b0 100644
>> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
>> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
>> @@ -2565,5 +2565,43 @@
>>         </tgroup>
>>        </table>
>>      </section>
>> +
>> +    <section>
>> +      <title>YCrCb Formats</title>
>> +
>> +      <para>YCbCr represents colors as a combination of three values:
>> +      <itemizedlist>
>> +       <listitem><para>Y - the luminosity (roughly the
>> brightness)</para></listitem>
>> +       <listitem><para>Cb - the chrominance of the blue
>> primary</para></listitem>
>> +       <listitem><para>Cr - the chrominance of the red
>> primary</para></listitem>
>
> How does that differ from YUV ?


I need to say that I am very new to this whole format stuff and so I
am not really sure.
In the data sheet
http://dxr3.sourceforge.net/download/hardware/ADV7175A_6A.pdf there is
on the
first page a FUNCTIONAL BLOCK DIAGRAM which shows that there is a
"YCrCb to YUV Matrix"
stage in the pipeline. I am also fine to use a YUV format for the media bus.
Any suggestions?

Greets,
--
Christian Gmeiner, MSc
