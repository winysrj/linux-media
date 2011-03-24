Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47627 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1CXO6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 10:58:08 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LIK000PPHKSJV@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Mar 2011 14:58:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LIK00HOSHKQLD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Mar 2011 14:58:03 +0000 (GMT)
Date: Thu, 24 Mar 2011 15:58:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC/PATCH] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
In-reply-to: <201103241538.43283.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4D8B5BFA.3090205@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1300976395-23826-1-git-send-email-s.nawrocki@samsung.com>
 <201103241538.43283.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

thanks for your comments.

On 03/24/2011 03:38 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Thursday 24 March 2011 15:19:54 Sylwester Nawrocki wrote:
>> Add V4L2_MBUS_FMT_JPEG_1X8 format and the corresponding Docbook
>> documentation.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>
>> Hi all,
>>
>> I would like to propose and addition of JPEG format to the list
>> of media bus formats. The requirement of this format had already
>> been discussed in the past [1], [2].
>> This patch adds relevant entry in v4l2-mediabus.h header and
>> the documentation. Initially I have added only bus width information
>> to the format code. I am not sure what other information could be
>> included. I am open to suggestions if anyone knows about any other
>> requirements.
>>
>> JPEG format on media bus is, among others, required for Samsung
>> S5P MIPI CSI receiver [3] and M-5MOLS camera drivers [4].
>>
>> Comments are welcome!
>>
>> --
>> Regards,
>> Sylwester Nawrocki,
>> Samsung Poland R&D Center
>>
>> [1] http://www.spinics.net/lists/linux-media/msg27980.html
>> [2] http://www.spinics.net/lists/linux-media/msg28651.html
>> [3] http://www.spinics.net/lists/linux-samsung-soc/msg03807.html
>> [4] http://lwn.net/Articles/433836/
>> ---
>>  Documentation/DocBook/v4l/subdev-formats.xml |   45
>> ++++++++++++++++++++++++++ include/linux/v4l2-mediabus.h                | 
>>   3 ++
>>  2 files changed, 48 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/v4l/subdev-formats.xml
>> b/Documentation/DocBook/v4l/subdev-formats.xml index b5376e2..60a6fe2
>> 100644
>> --- a/Documentation/DocBook/v4l/subdev-formats.xml
>> +++ b/Documentation/DocBook/v4l/subdev-formats.xml
>> @@ -2463,5 +2463,50 @@
>>  	</tgroup>
>>        </table>
>>      </section>
>> +
>> +    <section>
>> +      <title>JPEG Compressed Formats</title>
>> +
>> +      <para>Those data formats are used to transfer arbitrary byte-based
>> image +	data obtained from JPEG compression process. The format code
>> +	is made of the following information.
>> +	<itemizedlist>
>> +	  <listitem>The bus width in bits.</listitem>
>> +	</itemizedlist>
>> +
>> +	<para>For instance, a format where bus width is 8 bits will be named
>> +	  <constant>V4L2_MBUS_FMT_JPEG_1X8</constant>.
>> +	</para>
>> +
>> +      </para>
>> +
>> +      <para>The following table lists existing JPEG compressed
>> formats.</para> +
>> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-jpeg">
>> +	<title>JPEG Formats</title>
>> +	<tgroup cols="23">

Oops, looks like I've send wrong patch version. That should read 

<tgroup cols="3">

>> +	  <colspec colname="id" align="left" />
>> +	  <colspec colname="code" align="left"/>
>> +	  <colspec colname="remarks" align="left"/>
>> +	  <thead>
>> +	    <row>
>> +	      <entry>Identifier</entry>
>> +	      <entry>Code</entry>
>> +	      <entry>Remarks</entry>
>> +	    </row>
>> +	  </thead>
>> +	  <tbody valign="top">
>> +	    <row id="V4L2-MBUS-FMT-JPEG-1X8">
>> +	      <entry>V4L2_MBUS_FMT_JPEG_1X8</entry>
>> +	      <entry>0x4001</entry>
>> +	      <entry> This format shall be used for of transmission of JPEG

..and s/for of/for

>> +		data over MIPI CSI-2 bus with User Defined 8-bit Data types.
> 
> JPEG formats are not limited to MIPI, some parallel sensors can transmit JPEG 
> as well.

Yes, I am aware of that. One of examples could be the old TCM8240MD sensor.
http://www.sparkfun.com/datasheets/Sensors/Imaging/TCM8240MD_E150405_REV13.pdf

My intention was to indicate that V4L2_MBUS_FMT_JPEG_1X8 format is
the preferred one for "User Defined 8-bit Data Transmission" over 
the serial MIPI-CSI link.

I'm not sure if "Remarks" column is needed.

Maybe something like:
...
+	<entry>0x4001</entry>
+	<entry> This format is recommended for transmission of JPEG
+	 data over MIPI CSI-2 bus with User Defined 8-bit Data types.
+	<entry> 
...

would be better?

--
Regards,
Sylwester




-- 
Sylwester Nawrocki
Samsung Poland R&D Center
