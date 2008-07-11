Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BIKwdj023503
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 14:20:58 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6BIKgHp027465
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 14:20:42 -0400
Message-ID: <4877A4A0.4020606@free.fr>
Date: Fri, 11 Jul 2008 20:21:20 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Malsoaz James <jmalsoaz@yahoo.fr>
References: <122708.39761.qm@web28403.mail.ukl.yahoo.com>
In-Reply-To: <122708.39761.qm@web28403.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Re : Own software to use a camera
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

Malsoaz James a écrit :
> Thank you for your help, I will have a look at that.
> 
> Have you any document about the function present in this library ? I mean information on the arguments used in each function, list of the functions and their goal, ...
> 
Not yet... I plan to do something for my own understanding.
> For example, for v4l2_open, there is a char * = /dev/video0 and then a flag certainly O_RDWR, ...
> 
These calls shall have the same behavior than the v4l2 driver ones. So you can refer to the v4l2 API.
http://www.linuxtv.org/v4lwiki/index.php/Development:_Video4Linux_APIs
> 
> ----- Message d'origine ----
> De : Thierry Merle <thierry.merle@free.fr>
> À : David Ellingsworth <david@identd.dyndns.org>
> Cc : Malsoaz James <jmalsoaz@yahoo.fr>; video4linux-list@redhat.com
> Envoyé le : Jeudi, 10 Juillet 2008, 12h08mn 14s
> Objet : Re: Own software to use a camera
> 
> David Ellingsworth a écrit :
>> James,
>>
>> I suspect you may benefit from using the new v4l-library. It should
>> help simplify the conversion of whatever format the camera supports
>> into whichever format your application desires. The current
>> development branch of the library is located here:
>> http://linuxtv.org/hg/~tmerle/v4l2-library/
>>
>> Regards,
>>
>> David Ellingsworth
>>  
> And now this library is integrated in the current v4l-dvb branch
> http://linuxtv.org/hg/v4l-dvb
> You will find the lib in v4l2-apps/lib/libv4l..
> All this work was made by Hans de Goede.
> 
> Cheers,
> Thierry
> 
> 
> 
>       _____________________________________________________________________________ 
> Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.yahoo.fr
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=subscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 


-- 
                   ,
                   }\      °
           _    .-`  `-.  o
           \`'./     (o)\
            ) >   )))    } O
           /_.'\     / \/
       jgs      `'---'=`     http://thierry.merle.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
