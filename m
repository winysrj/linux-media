Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8C6aHW032680
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 07:06:36 -0500
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8C5cll016066
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 07:06:05 -0500
Message-ID: <493D0D86.3080108@nokia.com>
Date: Mon, 08 Dec 2008 14:05:26 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: "ext Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
References: <A24693684029E5489D1D202277BE894415C11947@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894415C11947@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

ext Aguirre Rodriguez, Sergio Alberto wrote:
> Although the end result of making OMAP3 cam driver independent from
> ISP doesn't make much sense to me, as in OMAP3 the ISP is needed even
> for the minimal handling required for receiving data from the sensors
> that the camera driver supports. (Minimal datapath is CCP2->SDRAM or
> CSI2->SDRAM, and that requires ISP MMU and the corresponding
> receivers, which are considered part of the ISP)

The benefit is that this driver could have use beyond the OMAP 3 
platform as it could be used with other ISPs. It's not dependent on any 
particular sensors either.

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
