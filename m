Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8BMD6Y3005926
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 18:13:07 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8BMBpjE021064
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 18:11:51 -0400
Received: by ug-out-1314.google.com with SMTP id o38so889350ugd.13
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 15:11:50 -0700 (PDT)
Message-ID: <de8cad4d0809111511n77187b72rc50e18f1acc0176a@mail.gmail.com>
Date: Thu, 11 Sep 2008 18:11:50 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Jay R. Ashworth" <jra@baylink.com>
In-Reply-To: <20080911205949.GB30564@cgi.jachomes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0809081443o39bf9a17vc804e86981f2170e@mail.gmail.com>
	<de8cad4d0809090618m44d906bn10101fd51cf9938e@mail.gmail.com>
	<20080911205949.GB30564@cgi.jachomes.com>
Cc: video4linux-list@redhat.com
Subject: Re: Recommended 2 input hardware encoder
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

On Thu, Sep 11, 2008 at 4:59 PM, Jay R. Ashworth <jra@baylink.com> wrote:
> On Tue, Sep 09, 2008 at 09:18:08AM -0400, Brandon Jenkins wrote:
>> Thanks for the replies thus far. I should have clearly stated the
>> second bracket requirement of the PVR-500 is a stopper for me. I am
>> looking to build a machine which is capable of 10 analog captures
>> using 5 PCI boards via svideo and l/r audio.
>
> Yup, you should.  You may have interrupt and bus-bandwidth problems at
> that level.  It's definitely going to be critical what motherboard and
> disk controller you pick.  Is there any reason you can't put it in
> multiple chassis?
>
> Cheers,
> -- jra
> --
> Jay R. Ashworth                   Baylink                      jra@baylink.com
> Designer                     The Things I Think                       RFC 2100
> Ashworth & Associates     http://baylink.pitas.com                     '87 e24
> St Petersburg FL USA      http://photo.imageinc.us             +1 727 647 1274
>
>             Those who cast the vote decide nothing.
>             Those who count the vote decide everything.
>               -- (Josef Stalin)
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Jay,

Thanks for the reply. A separate chassis would require administrating
a second system or getting a PCI expansion box. Both doable, but I'd
rather cram it all into one system and test the loading.

FWIW - Supermicro MB and PCI-E add on card for storage.

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
