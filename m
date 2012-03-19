Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40391 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2CSW7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:59:37 -0400
Received: by bkcik5 with SMTP id ik5so4682588bkc.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 15:59:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAUSrfF+XiPaoSkYYxVFKSH-nA0n=+6rfqy7ah5BBV7DE81jWw@mail.gmail.com>
References: <CAEN_-SC1bPX-SWS5ZV7=7ANTAhbjEQpUTog7GATOxTJqyq+R-w@mail.gmail.com>
	<4EF3B1D3.3040500@aapt.net.au>
	<CAAUSrfF+XiPaoSkYYxVFKSH-nA0n=+6rfqy7ah5BBV7DE81jWw@mail.gmail.com>
Date: Tue, 20 Mar 2012 09:59:36 +1100
Message-ID: <CAAUSrfHspbrOY8wmxsbtYTQ12DKGR7MRAaOzg5+J2K8txW4nFg@mail.gmail.com>
Subject: Re: cx88: all radio tuners using xc2028 or xc4000 tuner and radio
 should have radio_type UNSET
From: Andrew Goff <goffa72@gmail.com>
To: =?UTF-8?Q?Miroslav_Sluge=C5=88?= <thunder.mmm@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Miroslav,

After applying an update and installing the most recent V4L drivers
the radio is not working again. It appears that not all your patches
have been included in the current media build and the patches can not
be successfully applied.


> 2011/12/23 Andrew Goff <goffa72@gmail.com>
>>
>> Thanks Miroslav,
>>
>> your patches fixed the problems with my leadtek 1800H card. Radio now works again and tunes to the correct frequency.
>>
>> On 17/12/2011 11:55 AM, Miroslav Slugeň wrote:
>>>
>>> Fix radio for cx88 driver.
>
>
