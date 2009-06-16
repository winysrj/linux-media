Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37211 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZFPOd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 10:33:58 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Tue, 16 Jun 2009 09:33:54 -0500
Subject: RE: [PATCH RFC] adding support for setting bus parameters in sub
 	device
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF9703@dlee06.ent.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
	 <aec7e5c30906142157t313e7c95v3d1ab19f80745cf5@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40139DF92A6@dlee06.ent.ti.com>
 <aec7e5c30906152102r27aa2894q857be2ffb30d1d45@mail.gmail.com>
In-Reply-To: <aec7e5c30906152102r27aa2894q857be2ffb30d1d45@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


<snip>
>>
>> [MK]In that case can't the driver just ignore the field polarity? I
>assume that drivers implement the parameter that has support in hardware.
>So it is not an issue.
>
>No, because the same driver runs on hardware that also has the field
>signal. So we need to be able to give information about which signals
>that the board actually implement. We already do this with the
>soc_camera framework and it is working just fine.


Hardware with field signal used (driver use polarity from platform data and set it in the hardware)
Hardware with field signal not used (In this case, even though the driver sets it in the hardware, it is not really used in the hardware design and hence is a don't care. right?

So I don't see why it matters. 

Murali
>
>Thanks for your comment!
>
>/ magnus

