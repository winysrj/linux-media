Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51489 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2GZEPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 00:15:18 -0400
Received: by vbbff1 with SMTP id ff1so1279321vbb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 21:15:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50105A67.9010709@gmail.com>
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
	<1343219191-3969-2-git-send-email-shaik.ameer@samsung.com>
	<50105A67.9010709@gmail.com>
Date: Thu, 26 Jul 2012 09:45:17 +0530
Message-ID: <CAOD6ATq=_mr1tEvC0_aVzHzcb-6DJXFytBhNiT+Gn+1XFTXiXw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] v4l: Add new YVU420 multi planar fourcc definition
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 26, 2012 at 2:13 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Shaik,
>
>
> On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
>>
>> This patch adds the following new fourcc definition.
>> For multiplanar YCrCb
>>          - V4L2_PIX_FMT_YVU420M - 'YVUM'
>>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |   97
>> +++++++++++++++++---
>
>
> Can you please add a new xml file for this new format, rather than
> modifying this one ? I think it would be more clear this way.
>

Ok. No problem. I can create a new xml file for this format..

>>   include/linux/videodev2.h                          |    1 +
>>   2 files changed, 84 insertions(+), 14 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
>> b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
>> index 60308f1..9fc9a2e 100644
>> --- a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
>> +++ b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
>> @@ -1,12 +1,14 @@
>> -<refentry id="V4L2-PIX-FMT-YUV420M">
>> +<refentry>
>>         <refmeta>
>> -       <refentrytitle>V4L2_PIX_FMT_YUV420M ('YM12')</refentrytitle>
>> +       <refentrytitle>V4L2_PIX_FMT_YUV420M ('YM12'), V4L2_PIX_FMT_YVU420M
>> ('YMUM')</refentrytitle>
>>         &manvol;
>>         </refmeta>
>>         <refnamediv>
>> -       <refname>  <constant>V4L2_PIX_FMT_YUV420M</constant></refname>
>> -       <refpurpose>Variation of<constant>V4L2_PIX_FMT_YUV420</constant>
>> -         with planes non contiguous in memory.</refpurpose>
>> +       <refname
>> id="V4L2_PIX_FMT_YUV420M"><constant>V4L2_PIX_FMT_YUV420M</constant></refname>
>> +       <refname
>> id="V4L2_PIX_FMT_YVU420M"><constant>V4L2_PIX_FMT_YVU420M</constant></refname>
>> +       <refpurpose>Variation of<constant>V4L2_PIX_FMT_YUV420</constant>,
>> +       <constant>V4L2_PIX_FMT_YVU420</constant>  respectively with planes
>> non contiguous in memory.
>> +               </refpurpose>
>>         </refnamediv>
>>
>>         <refsect1>
>> @@ -16,29 +18,34 @@
>>   The three components are separated into three sub- images or planes.
>>
>>   The Y plane is first. The Y plane has one byte per pixel. The Cb data
>> -constitutes the second plane which is half the width and half
>> -the height of the Y plane (and of the image). Each Cb belongs to four
>> +constitutes the second plane for<constant>V4L2_PIX_FMT_YUV420M</constant>
>> format
>> +and the third plane for<constant>V4L2_PIX_FMT_YVU420M</constant>  format,
>> +which is half the width and half the height of the Y plane (and of the
>> image).
>> +Each Cb belongs to four
>>   pixels, a two-by-two square of the image. For example,
>>   Cb<subscript>0</subscript>  belongs to Y'<subscript>00</subscript>,
>>   Y'<subscript>01</subscript>, Y'<subscript>10</subscript>, and
>> -Y'<subscript>11</subscript>. The Cr data, just like the Cb plane, is
>> -in the third plane.</para>
>> +Y'<subscript>11</subscript>. The Cr data, just like the Cb data,
>> constitutes
>> +the third plane for<constant>V4L2_PIX_FMT_YUV420M</constant>  format and
>> +the second plane for<constant>V4L2_PIX_FMT_YVU420M</constant>
>> format.</para>
>>
>>         <para>If the Y plane has pad bytes after each row, then the Cb
>>   and Cr planes have half as many pad bytes after their rows. In other
>> -words, two Cx rows (including padding) is exactly as long as one Y row
>> +words, two Cx rows (including padding) are exactly as long as one Y row
>>   (including padding).</para>
>>
>> -       <para><constant>V4L2_PIX_FMT_NV12M</constant>  is intended to be
>> +       <para><constant>V4L2_PIX_FMT_YUV420M</constant>,
>> +<constant>V4L2_PIX_FMT_YVU420M</constant>  are intended to be
>>   used only in drivers and applications that support the multi-planar API,
>>   described in<xref linkend="planar-apis"/>.</para>
>>
>>         <example>
>> -       <title><constant>V4L2_PIX_FMT_YVU420M</constant>  4&times; 4
>>
>> -pixel image</title>
>> +       <title><constant>V4L2_PIX_FMT_YUV420M</constant>,
>> +               <constant>V4L2_PIX_FMT_YVU420M</constant>  4&times; 4
>>
>> +               pixel image</title>
>>
>>         <formalpara>
>> -       <title>Byte Order.</title>
>> +       <title>Byte Order for V4L2_PIX_FMT_YUV420M.</title>
>>         <para>Each cell is one byte.
>>                 <informaltable frame="none">
>>                 <tgroup cols="5" align="center">
>> @@ -101,6 +108,68 @@ pixel image</title>
>>         </formalpara>
>>
>>         <formalpara>
>> +       <title>Byte Order for V4L2_PIX_FMT_YVU420M.</title>
>> +       <para>Each cell is one byte.
>> +               <informaltable frame="none">
>> +               <tgroup cols="5" align="center">
>> +               <colspec align="left" colwidth="2*" />
>> +               <tbody valign="top">
>> +               <row>
>> +               <entry>start0&nbsp;+&nbsp;0:</entry>
>> +               <entry>Y'<subscript>00</subscript></entry>
>> +               <entry>Y'<subscript>01</subscript></entry>
>> +               <entry>Y'<subscript>02</subscript></entry>
>> +               <entry>Y'<subscript>03</subscript></entry>
>> +               </row>
>> +               <row>
>> +               <entry>start0&nbsp;+&nbsp;4:</entry>
>> +               <entry>Y'<subscript>10</subscript></entry>
>> +               <entry>Y'<subscript>11</subscript></entry>
>> +               <entry>Y'<subscript>12</subscript></entry>
>> +               <entry>Y'<subscript>13</subscript></entry>
>> +               </row>
>> +               <row>
>> +               <entry>start0&nbsp;+&nbsp;8:</entry>
>> +               <entry>Y'<subscript>20</subscript></entry>
>> +               <entry>Y'<subscript>21</subscript></entry>
>> +               <entry>Y'<subscript>22</subscript></entry>
>> +               <entry>Y'<subscript>23</subscript></entry>
>> +               </row>
>> +               <row>
>> +               <entry>start0&nbsp;+&nbsp;12:</entry>
>> +               <entry>Y'<subscript>30</subscript></entry>
>> +               <entry>Y'<subscript>31</subscript></entry>
>> +               <entry>Y'<subscript>32</subscript></entry>
>> +               <entry>Y'<subscript>33</subscript></entry>
>> +               </row>
>> +               <row><entry></entry></row>
>> +               <row>
>> +               <entry>start1&nbsp;+&nbsp;0:</entry>
>> +               <entry>Cr<subscript>00</subscript></entry>
>> +               <entry>Cr<subscript>01</subscript></entry>
>> +               </row>
>> +               <row>
>> +               <entry>start1&nbsp;+&nbsp;2:</entry>
>> +               <entry>Cr<subscript>10</subscript></entry>
>> +               <entry>Cr<subscript>11</subscript></entry>
>> +               </row>
>> +               <row><entry></entry></row>
>> +               <row>
>> +               <entry>start2&nbsp;+&nbsp;0:</entry>
>> +               <entry>Cb<subscript>00</subscript></entry>
>> +               <entry>Cb<subscript>01</subscript></entry>
>> +               </row>
>> +               <row>
>> +               <entry>start2&nbsp;+&nbsp;2:</entry>
>> +               <entry>Cb<subscript>10</subscript></entry>
>> +               <entry>Cb<subscript>11</subscript></entry>
>> +               </row>
>> +               </tbody>
>> +               </tgroup>
>> +               </informaltable>
>> +       </para>
>> +       </formalpara>
>> +       <formalpara>
>>         <title>Color Sample Location.</title>
>>         <para>
>>                 <informaltable frame="none">
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index dbf9d3a..80962b8 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -365,6 +365,7 @@ struct v4l2_pix_format {
>>
>>   /* three non contiguous planes - Y, Cb, Cr */
>>   #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12
>> YUV420 planar */
>> +#define V4L2_PIX_FMT_YVU420M v4l2_fourcc('Y', 'V', 'U', 'M') /* 12
>> YVU420 planar */
>>
>>   /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
>>   #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8
>> BGBG.. GRGR.. */
>
>
> --
>
> Thanks,
> Sylwester
