Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37344 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2CGFti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 00:49:38 -0500
Received: by qcqw6 with SMTP id w6so3005767qcq.19
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2012 21:49:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ADF13DA15EB3FE4FBA487CCC7BEFDF36270347EFE4@bssrvexch01>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36270347EFE4@bssrvexch01>
Date: Wed, 7 Mar 2012 11:19:38 +0530
Message-ID: <CAK9yfHwWprfc2h5Fg5jJPovFuBS2o9c8gfTCfe3HNnDE9Ocufg@mail.gmail.com>
Subject: Re: V4L2 MFC video decoding example application
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	"mika.kamppuri@symbio.com" <mika.kamppuri@symbio.com>,
	"jari.issakainen@symbio.com" <jari.issakainen@symbio.com>,
	"thomas.langas@fxitech.com" <thomas.langas@fxitech.com>,
	"dakuit00@googlemail.com" <dakuit00@googlemail.com>,
	"brian@seedmorn.cn" <brian@seedmorn.cn>,
	"dron0gus@gmail.com" <dron0gus@gmail.com>,
	"sawyer@seedmorn.cn" <sawyer@seedmorn.cn>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	"subash.ramaswamy@linaro.org" <subash.ramaswamy@linaro.org>,
	"maheshbhairodagi@gmail.com" <maheshbhairodagi@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"naveen.ch@samsung.com" <naveen.ch@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jtp.park@samsung.com" <jtp.park@samsung.com>,
	"jaeryul.oh@samsung.com" <jaeryul.oh@samsung.com>,
	Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Thank you for this really cool app.
Tested on Origen board for MPEG4 and H.264 streams and they work fine.

Regards,
Sachin

On 06/03/2012, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
> I would like to inform you that the example application for the MFC driver
> has been prepared and was today released to the open source.
>
> The application demonstrates how to setup and handle video stream decoding.
> It uses MFC for video decoding and FIMC for post processing (color
> conversion and scaling). The resulting image is displayed using the frame
> buffer. The main goal was releasing a simple and easy to understand example
> application. I hope that it will prove useful and clear.
>
> The code can be found here:
> http://git.infradead.org/users/kmpark/public-apps/tree/HEAD:/v4l2-mfc-example
>
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>
>
>
> The above message is intended solely for the named addressee and may contain
> trade secret, industrial technology or privileged and confidential
> information otherwise protected under applicable law. Any unauthorized
> dissemination, distribution, copying or use of the information contained in
> this communication is strictly prohibited. If you have received this
> communication in error, please notify sender by email and delete this
> communication immediately.
>
>
> Powy¿sza wiadomo¶æ przeznaczona jest wy³±cznie dla adresata niniejszej
> wiadomo¶ci i mo¿e zawieraæ informacje bêd±ce tajemnic± handlow±, tajemnic±
> przedsiêbiorstwa oraz informacje o charakterze poufnym chronione
> obowi±zuj±cymi przepisami prawa. Jakiekolwiek nieuprawnione ich
> rozpowszechnianie, dystrybucja, kopiowanie lub u¿ycie informacji zawartych w
> powy¿szej wiadomo¶ci jest zabronione. Je¶li otrzyma³e¶ powy¿sz± wiadomo¶æ
> omy³kowo, uprzejmie proszê poinformuj o tym fakcie drog± mailow± nadawcê tej
> wiadomo¶ci oraz niezw³ocznie usuñ powy¿sz± wiadomo¶æ ze swojego komputera.
>


-- 
With warm regards,
Sachin
