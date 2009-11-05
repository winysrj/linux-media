Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA59ijwb013460
	for <video4linux-list@redhat.com>; Thu, 5 Nov 2009 04:44:45 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA59iTFm016532
	for <video4linux-list@redhat.com>; Thu, 5 Nov 2009 04:44:30 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1576395eye.23
	for <video4linux-list@redhat.com>; Thu, 05 Nov 2009 01:44:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fe6fd5f60911050108w58713a74qa33c496fbb9542ec@mail.gmail.com>
References: <fe6fd5f60911050108w58713a74qa33c496fbb9542ec@mail.gmail.com>
Date: Thu, 5 Nov 2009 10:44:28 +0100
Message-ID: <eedb5540911050144r770b046fpfcd5aa23281bfe0@mail.gmail.com>
From: javier Martin <javier.martin@vista-silicon.com>
To: Carlos Lavin <carlos.lavin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: function to_soc_camera_link(icd);
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

2009/11/5 Carlos Lavin <carlos.lavin@vista-silicon.com>:
> hello!, any people to know to used this function:
>
> to_soc_camera_link(icd)
>
>  i make a driver and i have a problem whit this function, this function is
> used for the version 2.6.32 but i want to use for the version 2.6.30, this
> driver is for a sensor ov7670, but i don't know how i used it.

Hi Carols,
if you are completely lost you could try a hard ' git log -p | less '
inside v4l repository and then search for this function to see when it
was added and what does it do.

Also you can use http://lxr.linux.no/  to search for functions in
every kernel release as long as they have been entered mainline.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
