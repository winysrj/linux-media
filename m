Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38995 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1CDJSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:18:23 -0500
Received: by qwd7 with SMTP id 7so1515893qwd.19
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2011 01:18:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim3=qq_NHzxOKEQzi21MPmhDdYvHNxpHDHr4O96@mail.gmail.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36190F532AED@bssrvexch01>
	<000001cbd7fd$1868a500$4939ef00$%szyprowski@samsung.com>
	<000001cbd825$1954f9a0$4bfeece0$%szyprowski@samsung.com>
	<AANLkTim3=qq_NHzxOKEQzi21MPmhDdYvHNxpHDHr4O96@mail.gmail.com>
Date: Fri, 4 Mar 2011 10:18:21 +0100
Message-ID: <AANLkTi=7ehCPRJZQLt8YhteQCJDqKhWmQXiV3yf2Tm+O@mail.gmail.com>
Subject: Re: V4L2 'brainstorming' meeting in Warsaw, March 2011
From: Robert Fekete <robert.fekete@linaro.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, willy.poisson@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 Hi,

 I would gladly join this meeting but unfortunately I cannot attend. On the
 other hand I am glad to present that Willy Poisson from ST-Ericsson can
 join. Willy will mainly focus on Camera/imaging parts in which we believe
 V4L2 may fit very well.


 Some comments:

 Regarding OGL/ES in V4L2 I do not quite get the connection. As long as there
 is a common system memory handle...like hwmem any buffer dequeued from a
 camera or video decoder automatically slips into GLES...right. Of course the
 GL hw driver must also be aware of hwmem and accept the bufferformat used.

 Regarding HDMI API: We have some thoughts here as well...I'll get back to
 you.

 Regarding Buffer Pool: As you already know hwmem is one proposal but we are
 moving more towards GEM(since it's there already) with hwmem style though
 with CMA at the bottom....I'll get back to you on this matter as well.

 Have a nice meeting in Warsaw!

 BR
 /Robert Fekete
 (robert.fekete@stericsson.com)


> On 1 March 2011 16:26, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>>
>> Hello once more,
>>
>> After some discussion on #v4l irc channel, I would like to inform that the
>> meeting
>> date has been fixed to my initial proposition: 3 days from 16 to 18 March
>> 2011.
>>
>> Best regards
>> --
>> Marek Szyprowski
>> Samsung Poland R&D Center
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
