Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KwKYd-0004Hs-VU
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 18:46:45 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1504185fga.25
	for <linux-dvb@linuxtv.org>; Sat, 01 Nov 2008 10:46:40 -0700 (PDT)
Message-ID: <d9def9db0811011046t58a03e3aj612cdcb06d042ca1@mail.gmail.com>
Date: Sat, 1 Nov 2008 18:46:40 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Thierry Merle" <thierry.merle@free.fr>
In-Reply-To: <490C2432.40804@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
References: <490B7EE5.5030701@powercraft.nl> <490C2432.40804@free.fr>
Cc: akpm@osdl.org, greg@kroah.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	em28xx@mcentral.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] em28xx merge process issues with linuxtv and
	upstream kernel
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, Nov 1, 2008 at 10:41 AM, Thierry Merle <thierry.merle@free.fr> wrot=
e:
> Hi Jelle,
>
> Jelle de Jong a =E9crit :
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hello everybody,
>>
>> I would like to discuss some issues with the em28xx-new project and the
>> re-merging process with the upstream code and the linuxtv project.
>>
>> First I would like to say that I am not an active developer on this
>> project, but a very heavy user that followed the project very close and
>> made some documentation, packages, helped getting some issues discussed
>> and some devices added. This project is important for me because I need
>> it to be merged successfully and with width support so it will become
>> maintainable on large basis.
>>
>> This is the situation:
>>
>> Markus Rechberger has worked for more than 3 years on a clone/fork of
>> the official code, creating the em28xx-new [1] project. He has worked
>> very very hard on this project and produced a lot of code and provides a
>> lot of support to the users of his project. It takes lot of energy and
>> resources to pull of this kind of work! I do really respect this work
>> and hope others also do this!
>>
>> In a good free software development process somebody would clone some
>> work to his own personal repository, then add or fix one feature. Create
>> a diff compared with the upstream code and then. Commit the patch with
>> good description to the upstream project, so this feature and its code
>> changes can be reviewed, tested and supported. After this one feature
>> fix and patch, a developer moves to his next feature and repeats to
>> process so step by step and patch by patch the project grows. This
>> understanding of the code bye a larger group of people will lead to a
>> platform of developers that can maintain and contribute to the project.
>> This would be the proper way of doing things it most cases, but a
>> developer need to know and understand or mentored with this from the sta=
rt.
>>
>> However sometimes a developer works very hard on the code creating lots
>> of new features, adding support for lots of new devices and fixes lots
>> of issues without committing patches during the process. After 3 years
>> or more its understandable that it can lead to a code base almost
>> unrecognizable from the initial cloned code base. So what to do now! To
>> ask from the developer to completely separate all his work in individual
>> patches that can be committed to upstream is almost unrealistic. A good
>> plan needs to be created and discussed by the people that matter.
>>
>> In this case I have seen several attempts of Markus to make large
>> patches and some smaller to try getting his code merged upstream, but
>> they were after short discussion rejected, because they did not fit the
>> one patch for one fix, feature, etcetera standard/idea.
>>
> The last attempt was rejected because the patches were adding duplicate d=
rivers rather than improving the existing ones.
> In the same project, 2 drivers managing the same hardware is not correct.
> Markus (or another people, why Markus may be the only person to do that?)=
 should propose patches of the existing drivers, without breaking the v4l-d=
vb APIs.
> - First, the tuners and video decoders modifications shall be merged sinc=
e they are used by several existing drivers.
> - Then the em28xx driver shall be improved.
> And this is what Markus started (thanks for this initiative) but this is =
hard to spend time on these minor things while supporting problems because =
of being out-of-kernel.
>

In case of the cx25843 I discussed it with Hans Verkuil, there's more
or less no option since it collides with the existing inkernel driver
and disables support for other
cx25843 drivers, so as for the kernel it should be merged to the
existing one yes.
The em28xx driver, the one in the kernel has taken a few patches from
my repository, and it has some additional custom patches, it would
make more sense to work those
few patches into the new em28xx driver which is tested with most devices

(compared with the driver which is in the kernel which is likely
tested with 5-10% of the devices which are in the cardlist).

As for some reasons why not to merge it back then:
* the driver relied on reverse engineered code, which made some
devices extremly hot (not even xc3028/xc3028L related). Wrong gpio
settings also enable the device to draw more power and affect the
signal strength for analog TV/dvb-t, those settings can be custom for
every designed device. I have had one pinnacle device which had a
slightly melted package because of that mess.

There are additional em28xx based chipdrivers which only work with
em28xx based devices (eg. videology cam).
The input layer actually fully works although I disabled it because it
needs a redesign and shouldn't be exposed to userland like this, also
the polling code shouldn't be used (linux timing causes
alot trouble at low intervals - especially the deinitialization of
such timers, I sent an email to the ML about a possible race condition
in ir-kbd-i2c a couple of months ago.
netBSD developers discovered that interrupt polling works fine even
for remote controls. Practically since I worked alot with remote
controls during the last half year returning keyboard input keys
to userland is a mess, there was a discussion also with netbsd people
about a more generic interface because the IR support of the device
should be seen as RC5/RC6/NEC/.. protocol support
and not as one interface where the device is bound to a certain remote
and only supporting that remote control.
(that's just the reason why IR support is disabled :)

I put together a summary of differences when I submitted the patches.
em28xx-new itself is a snapshot of the em28xx kernelcode which I
initially committed, and retried to merge a couple of times
over the years which luckily didn't work out (see almost melted
pinnacle device).

As incremented patches em28xx-new is more or less the inkernel em28xx
driver constantly worked on since the beginning of 2006.
First patches were available at:
http://mcentral.de/v4l-dvb/ (it was kept back along time because there
was no agreement over the useless API changes, other API changes have
been merged which aren't necessary either in that case). those patches
also would have added support for a couple of PCI devices, some of
them are still not merged either .. most of it relied on reverse
engineered code, I have to admit it was good to keep it out of the
kernel back then, it finally resulted in much better support and some
redesigned code.
That code was basically merged as a one shot into the em28xx-new
repository, everything that can be seen in that repository was
developed ontop of it and all the support for _all_ em28xx devices
which were supported by v4l-dvb-experimental are now supported by the
em28xx code too _since a couple of weeks_ (and not before).

> v4l-dvb people and Markus would be glad to see his drivers in the mainstr=
eam kernel.
>
>> I am going to ask for understanding of both the side of Markus that
>> worked very hard on his code, and that of the upstream developers. There
>> are both valid reasons on how they did there things.
>>
>> But we need a solution to get all the code back into the upstream
>> project so it can go into the kernel project and eventually be delivered
>> at the Linux distributions and all there users, so no custom compiling,
>> custom package install are required and non transparent bug reports can
>> be stopped.
>>
>> Is it possible for an upstream developer to step forward and take on the
>> task of merging the code of Markus back into mainstream, all questions
>> on the code can be discuses on several mailing-list [2] of choice.
>>
> Well, I would say: "Make it so!" ;)
>
>> Current the situation is kind of a hold-of, the issues are not being
>> discussed, the problem is not addressed, so no process is made and
>> during this time users are suffering from non working nor good supported
>> devices for there hybrid dvb-t/analog broadcast experiences under Linux.
>>
>> I hope this lead to a productive discussion that will get the code to
>> the end users through there main distribution systems.
>>
> I hope so, just to stop these useless discussions that do not discuss on =
patches.
>

the code is there :-)

br,
Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
