Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m826MWfW029624
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 02:22:33 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m826MJgD011010
	for <video4linux-list@redhat.com>; Tue, 2 Sep 2008 02:22:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 2 Sep 2008 08:22:18 +0200
References: <A24693684029E5489D1D202277BE89441191E342@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89441191E342@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809020822.18222.hverkuil@xs4all.nl>
Cc: 
Subject: Re: [PATCH 11/15] OMAP3 camera driver: Add ISP gain tables.
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

On Saturday 30 August 2008 01:42:23 Aguirre Rodriguez, Sergio Alberto 
wrote:
> From: Sergio Aguirre <saaguirre@ti.com>
> 
> OMAP: CAM: Add ISP gain tables
> 
> This adds the OMAP ISP gain tables. Includes:
> * Blue Gamma gain table
> * CFA gain table
> * Green Gamma gain table
> * Lens Shading Compensator gain table
> * Luma Enhancement gain table
> * Noise filter gain table
> * Red Gamma gain table
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/isp/bluegamma_table.h    | 1040 
+++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/cfa_coef_table.h     |  592 
+++++++++++++++++++++++++++++
>  drivers/media/video/isp/greengamma_table.h   | 1040 
+++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/ispccd_lsc.dat       |   97 ++++

Can you mail this again, but this time attach the patch? The 
ispccd_lsc.dat patch was corrupted due to the extremely long lines. 
BTW, the whole table has only 0x40 values in it. Perhaps time for a 
memset 0x40? Also, since ispccd_lsc.dat is included in a source I 
recommend renaming it to a .h file.

In general, please cleanup these headers. So rather than doing this:

/*
 * CFA Filter Coefficient Table
 *
 */
static u32 cfa_coef_table[] = {
#include "cfa_coef_table.h"
};

just move this to the cfa_coef_table.h header.

And instead of having the data layouted like this:

0,
247,
0,
244,
247,
36,
27,
12,
0,
27,
0,
250,

try to do it like this:

	  0, 247,   0, 244, 247,  36,
	 27,  12,   0,  27,   0, 250,

using, say, 8 or 10 values per line.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
