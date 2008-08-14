Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7EJVg0u016796
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 15:31:42 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7EJVcRL021974
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 15:31:39 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7EJVSNx015649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 14:31:33 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7EJVGBb015395
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 14:31:28 -0500 (CDT)
From: "Kulkarni, Pallavi" <p-kulkarni@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 14 Aug 2008 14:27:54 -0500
Message-ID: <496565EC904933469F292DDA3F1663E60F7943A1@dlee06.ent.ti.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Query about videobuf_vmalloc_to_sg() API
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

Hi All,
I am allocating a 10MB buffer in kernel space with the help of vmalloc call=
. To create a scatter-gather list dma, I am using videobuf_vmalloc_to_sg() =
API. But this API is not putting the value of dma_address field in the scat=
terlist structure. I think something is missing here and dma_address field =
must be set to a valid
physical address corresponding to the scatter-gather list entry.
Anyone has any idea if this is expected or any comments about this API?

Please let me know,

Thanks and regards,
Pallavi
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
