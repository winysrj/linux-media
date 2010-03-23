Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43912 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0CWRws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 13:52:48 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 23 Mar 2010 12:52:44 -0500
Subject: RE: [Resubmit: PATCH-V2] Introducing ti-media directory
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A785F05@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1268991350-549-1-git-send-email-hvaibhav@ti.com>
	<201003231241.00281.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E7394044DE0EBC5@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044DE0EBC5@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

>>
>> I'm not too sure to like the ti-media name. It will soon get quite
>crowded,
>> and name collisions might occur (look at the linux-omap-camera tree and
>the
>> ISP driver in there for instance). Isn't there an internal name to refer
>to
>> both the DM6446 and AM3517 that could be used ?
>[Hiremath, Vaibhav] Laurent,
>
>ti-media directory is top level directory where we are putting all TI
>devices drivers. So having said that, we should worrying about what goes
>inside this directory.
>For me ISP is more generic, if you compare davinci and OMAP.
>
>Frankly, there are various naming convention we do have from device to
>device, even if the IP's are being reused. For example, the internal name
>for OMAP is ISP but Davinci refers it as a VPSS.
>

Could you explain what name space issue you are referring to in linux-omap-camera since I am not quite familiar with that tree?

Myself and Vaibhav had discussed this in the past and ti-media is the generic name that we could agree on. On DM SoCs (DM6446, DM355, DM365) I expect ti-media to be the home for all vpfe and vpbe driver files. Since we had a case of common IP across OMAP and DMxxx SoCs, we want to place all OMAP and DMxxx video driver files in a common directory so that sharing
the drivers across the SoCs will be easy. We could discuss and agree on another name if need be. Any suggestions?

>Thanks,
>Vaibhav
>
>>
>> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
