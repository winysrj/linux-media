Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8DGEXRd003755
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 12:14:34 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8DGEMWu010984
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 12:14:23 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sat, 13 Sep 2008 18:14:26 +0200
References: <48C55737.4080804@nokia.com>
	<12208924933015-git-send-email-sakari.ailus@nokia.com>
	<12208924933079-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12208924933079-git-send-email-sakari.ailus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131814.27539.laurent.pinchart@skynet.be>
Cc: vimarsh.zutshi@nokia.com, Sakari Ailus <sakari.ailus@nokia.com>,
	vherkuil@xs4all.nl, tuukka.o.toivonen@nokia.com
Subject: Re: [PATCH 4/7] V4L: Add VIDIOC_G_PRIV_MEM ioctl
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

Hi Sakari,

On Monday 08 September 2008, Sakari Ailus wrote:
> Some devices, for example image sensors, contain settings in their
> EEPROM memory that are useful to userspace programs. VIDIOC_G_PRIV_MEM
> can be used to read those settings.

That doesn't really belong to the V4L2 API, does it ? Wouldn't it be better to 
export the data through sysfs ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
